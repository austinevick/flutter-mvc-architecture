import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/api.dart';
import '../model/search_history.dart';
import '../model/tmdb_movie_model.dart';
import '../providers.dart';
import '../service/search_history_repository_service.dart';

final movieSearchHistoryController =
    Provider((ref) => MovieSearchHistoryController());

class MovieSearchHistoryController {
  Future<bool> checkIfSearchedMovieExistInDatabase(int id) async {
    final movie = await getSearchHistory();
    bool isAvailable = false;
    for (var i = 0; i < movie.length; i++) {
      if (movie[i].movieId == id) {
        isAvailable = true;
      }
    }
    return isAvailable;
  }

  Future<List<SearchHistoryModel>> getSearchHistory() async {
    return await SearchHistoryRepository.getSearchHistory();
  }

  Future<int> saveSearchHistory(TMDBMovieResponseData movie) async {
    final model = SearchHistoryModel(
        overview: movie.overview,
        movieId: movie.id,
        title: movie.title,
        image: baseImageUrl + movie.posterPath!);
    final idExist = await checkIfSearchedMovieExistInDatabase(movie.id!);
    if (idExist) return 0;
    return await SearchHistoryRepository.saveSearchHistory(model);
  }

  Future<void> deleteSearchMovie(WidgetRef ref, int id) async {
    await SearchHistoryRepository.deleteSearchHistory(id)
        .whenComplete(() => ref.refresh(searchedMovieFutureProvider));
  }
}

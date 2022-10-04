import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/api.dart';
import '../../common/utils.dart';
import '../../model/tmdb_movie_model.dart';
import '../../model/saved_movie_model.dart';
import '../../service/local_movie_repository_service.dart';
import '../movie_detail_view/movie_detail_view_model.dart';
import 'home_view.dart';

final homeViewNotifier =
    StateNotifierProvider<HomeViewModel, bool>((ref) => HomeViewModel());

class HomeViewModel extends StateNotifier<bool> {
  HomeViewModel() : super(false);

  Future<void> saveMovie(WidgetRef ref, TMDBMovieResponseData model) async {
    final movie = SavedMovieModel(
        title: model.title,
        movieId: model.id,
        overview: model.overview,
        image: baseImageUrl + model.posterPath!);
    try {
      await LocalMovieRepositoryService.saveMovie(movie);
      Future.delayed(const Duration(seconds: 2), () {
        state = true;
        ref.refresh(saveMovieFutureProvider);
        ref.refresh(movieIdFutureProvider(model.id!));
      });
      showBottomFlash(content: 'Movie was successfully saved.');
    } catch (e) {
      showBottomFlash(content: 'Something went wrong');
      rethrow;
    }
  }

  void removeSavedMovie(WidgetRef ref, TMDBMovieResponseData m) async {
    try {
      state = true;
      final id = await getSavedMovieId(m.id!);
      deleteMovie(id);
      ref.refresh(saveMovieFutureProvider);
      Future.delayed(const Duration(seconds: 2),
          () => ref.refresh(movieIdFutureProvider(m.id!)));
      state = false;
    } catch (e) {
      state = false;
      rethrow;
    }
  }

  Future<int> getSavedMovieId(int id) async {
    var movie = await getSavedMovies();
    int movieId = 0;
    for (var i = 0; i < movie.length; i++) {
      if (movie[i].movieId == id) {
        movieId = movie[i].id!;
        print(movieId);
      }
    }
    return movieId;
  }

  Future<bool> checkIfMovieExistInDatabase(int id) async {
    final movie = await getSavedMovies();
    bool isAvailable = false;
    for (var i = 0; i < movie.length; i++) {
      if (movie[i].movieId == id) {
        isAvailable = true;
      }
    }
    return isAvailable;
  }

  Future<List<SavedMovieModel>> getSavedMovies() async {
    return await LocalMovieRepositoryService.getSavedMovies();
  }

  Future<void> deleteMovie(int id) async {
    await LocalMovieRepositoryService.deleteSearchMovie(id);
  }

  String emptyViewText =
      "No search history\nBegin by clicking the + button to search and save your favorite movies here.";
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/api.dart';
import '../common/utils.dart';
import '../model/movie_collection_model.dart';
import '../model/tmdb_movie_model.dart';
import '../providers.dart';
import '../service/movie_collection_repository_service.dart';

final movieCollectionController =
    StateNotifierProvider<MovieCollectionController, bool>(
        (ref) => MovieCollectionController());

class MovieCollectionController extends StateNotifier<bool> {
  MovieCollectionController() : super(false);

  Future<void> saveMovieToDevice(
      WidgetRef ref, TMDBMovieResponseData model) async {
    final movie = MovieCollectionModel(
        title: model.title,
        movieId: model.id,
        overview: model.overview,
        image: baseImageUrl + model.posterPath!);
    try {
      state = true;
      await MovieCollectionRepositoryService.saveMovie(movie);
      await Future.delayed(
        const Duration(seconds: 2),
      ).whenComplete(() {
        //state = true;
        ref.refresh(saveMovieFutureProvider);
        ref.refresh(movieExistInCollectionFutureProvider(model.id!));
      });
      showBottomFlash(content: 'Movie was successfully saved to device.');
      state = false;
    } catch (e) {
      state = false;
      showBottomFlash(content: somethingwentwrong);
      rethrow;
    }
  }

  void removeSavedMovie(WidgetRef ref, TMDBMovieResponseData m) async {
    try {
      state = true;
      final id = await getSavedMovieId(m.id!);
      await deleteMovie(id);
      ref.refresh(saveMovieFutureProvider);
      await Future.delayed(
        const Duration(seconds: 2),
      ).whenComplete(
          () => ref.refresh(movieExistInCollectionFutureProvider(m.id!)));
      showBottomFlash(content: 'Movie was successfully removed from device.');
      state = false;
    } catch (e) {
      state = false;
      rethrow;
    }
  }

  Future<int> getSavedMovieId(int id) async {
    var movie = await getSavedMovies();
    for (var i = 0; i < movie.length; i++) {
      if (movie[i].movieId == id) {
        return movie[i].id!;
      }
    }
    return 0;
  }

  Future<bool> checkIfMovieExistInDatabase(int id) async {
    final movie = await getSavedMovies();
    for (var i = 0; i < movie.length; i++) {
      if (movie[i].movieId == id) {
        return true;
      }
    }
    return false;
  }

  Future<List<MovieCollectionModel>> getSavedMovies() async {
    return await MovieCollectionRepositoryService.getSavedMovies();
  }

  Future<void> deleteMovie(int id) async {
    await MovieCollectionRepositoryService.deleteSearchMovie(id);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/api.dart';
import '../common/utils.dart';
import '../model/saved_movie_model.dart';
import '../model/tmdb_movie_model.dart';
import '../providers.dart';
import '../service/local_movie_repository_service.dart';

final movieCollectionController =
    StateNotifierProvider<MovieCollectionController, bool>(
        (ref) => MovieCollectionController());

class MovieCollectionController extends StateNotifier<bool> {
  MovieCollectionController() : super(false);

  Future<void> saveMovieToDevice(
      WidgetRef ref, TMDBMovieResponseData model) async {
    final movie = SavedMovieModel(
        title: model.title,
        movieId: model.id,
        overview: model.overview,
        image: baseImageUrl + model.posterPath!);
    try {
      state = true;
      await LocalMovieRepositoryService.saveMovie(movie);
      await Future.delayed(
        const Duration(seconds: 2),
      ).whenComplete(() {
        //state = true;
        ref.refresh(saveMovieFutureProvider);
        ref.refresh(movieExistInCollectionFutureProvider(model.id!));
      });
      showBottomFlash(content: 'Movie was successfully saved.');
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
}

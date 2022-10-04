import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_search_app/model/tmdb_movie_model.dart';
import '../../common/utils.dart';
import '../../model/yts_movie_model.dart';
import '../../service/remote_movie_repository_service.dart';
import '../home_view/home_view_model.dart';

final movieIdFutureProvider = FutureProvider.family((ref, int id) =>
    ref.watch(homeViewNotifier.notifier).checkIfMovieExistInDatabase(id));

final movieDetailViewNotifier = Provider((ref) => MovieDetailViewModel());

class MovieDetailViewModel {
  WidgetRef? ref;
  Future<YTSMoviesResponseModel> getYTSMovieDetailsById(String id) async {
    try {
      return await ref!
          .watch(movieRepositoryProvider)
          .getYTSMovieDetailsById(id);
    } on SocketException catch (_) {
      showBottomFlash(content: noConnection);
      rethrow;
    } catch (_) {
      showBottomFlash(content: somethingwentwrong);
      rethrow;
    }
  }

  Future<TMDBMovieResponseData> getTMDBMovieDetailsById(String id) async {
    try {
      return await ref!
          .watch(movieRepositoryProvider)
          .getTMDBMovieDetailsById(id);
    } on SocketException catch (_) {
      showBottomFlash(content: noConnection);
      rethrow;
    } catch (_) {
      showBottomFlash(content: somethingwentwrong);
      rethrow;
    }
  }
}

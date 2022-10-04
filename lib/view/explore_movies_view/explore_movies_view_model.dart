import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_search_app/model/tmdb_movie_model.dart';
import '../../common/utils.dart';
import '../../model/yts_movie_model.dart';
import '../../service/remote_movie_repository_service.dart';

final exploreMoviesViewNotifier = Provider((ref) => ExploreMoviesViewModel());

class ExploreMoviesViewModel {
  Future<List<YTSMoviesResponseModel>> getYTSMovies(WidgetRef ref) async {
    try {
      return await ref.watch(movieRepositoryProvider).getYTSMovies();
    } on SocketException catch (_) {
      showBottomFlash(content: 'No internet connection');
      rethrow;
    } catch (_) {
      showBottomFlash(content: 'Unknown error');
      rethrow;
    }
  }

  Future<List<TMDBMovieResponseData>?> getTMDBMovies(WidgetRef ref) async {
    try {
      return await ref.watch(movieRepositoryProvider).getTMDBMovies();
    } on SocketException catch (_) {
      showBottomFlash(content: 'No internet connection');
      rethrow;
    } catch (_) {
      showBottomFlash(content: 'Unknown error');
      rethrow;
    }
  }
}

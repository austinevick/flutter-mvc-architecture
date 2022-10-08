import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/utils.dart';
import '../model/tmdb_movie_model.dart';
import '../model/yts_movie_model.dart';
import '../service/remote_movie_repository_service.dart';

final movieRemoteRepositoryController =
    Provider.autoDispose((ref) => MovieRemoteRepositoryController());

class MovieRemoteRepositoryController {
  final ctrl = TextEditingController();
  WidgetRef? ref;

  Future<TMDBMovieResponseModel> searchTMDBMoviesByTitle(WidgetRef ref) async {
    try {
      return await ref
          .watch(movieRepositoryProvider)
          .searchTMDBMoviesByTitle(ctrl.text);
    } on SocketException catch (_) {
      showDialogFlash();
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
      showBottomFlash(content: 'No internet connection');
      rethrow;
    } catch (_) {
      showBottomFlash(content: 'Unknown error');
      rethrow;
    }
  }

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

  Future<List<YTSMoviesResponseModel>> getYTSMovies(WidgetRef ref) async {
    try {
      return await ref.watch(movieRepositoryProvider).getYTSMovies();
    } on SocketException catch (_) {
      rethrow;
    } catch (_) {
      showBottomFlash(content: somethingwentwrong);
      rethrow;
    }
  }

  Future<List<TMDBMovieResponseData>?> getTMDBMovies(WidgetRef ref) async {
    try {
      return await ref.watch(movieRepositoryProvider).getTMDBMovies();
    } on SocketException catch (_) {
      showDialogFlash();
      rethrow;
    } catch (_) {
      showBottomFlash(content: somethingwentwrong);
      rethrow;
    }
  }

  // Future<TMDBMovieResponseData> getTMDBMovieDetailsById(String id) async {
  //   try {
  //     return await ref!
  //         .watch(movieRepositoryProvider)
  //         .getTMDBMovieDetailsById(id);
  //   } on SocketException catch (_) {
  //     showBottomFlash(content: noConnection);
  //     rethrow;
  //   } catch (_) {
  //     showBottomFlash(content: somethingwentwrong);
  //     rethrow;
  //   }
  // }
}

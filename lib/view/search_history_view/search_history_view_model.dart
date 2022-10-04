import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_search_app/service/remote_movie_repository_service.dart';

import '../../common/api.dart';
import '../../common/utils.dart';
import '../../model/tmdb_movie_model.dart';
import '../../model/search_history.dart';
import '../../service/search_history_repository_service.dart';

final searchHistoryViewNotifier =
    Provider.autoDispose((ref) => SearchHistoryViewModel());

class SearchHistoryViewModel {
  final ctrl = TextEditingController();

  Future<TMDBMovieResponseModel> searchTMDBMoviesByTitle(WidgetRef ref) async {
    try {
      return await ref
          .watch(movieRepositoryProvider)
          .searchTMDBMoviesByTitle(ctrl.text);
    } on SocketException catch (_) {
      showBottomFlash(content: 'No internet connection');
      rethrow;
    } catch (_) {
      showBottomFlash(content: 'Unknown error');
      rethrow;
    }
  }

  Future<TMDBMovieResponseData> getTMDBMovieDetailsById(
      WidgetRef ref, String id) async {
    try {
      return await ref
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

  Future<List<SearchHistoryModel>> getSearchHistory() async {
    return await SearchHistoryRepository.getSearchHistory();
  }

  Future<int> saveSearchHistory(TMDBMovieResponseData movie) async {
    final model = SearchHistoryModel(
        title: movie.title, image: baseImageUrl + movie.posterPath!);
    return await SearchHistoryRepository.saveSearchHistory(model);
  }

  Future<void> deleteSearchMovie(int id) async {
    await SearchHistoryRepository.deleteSearchHistory(id);
  }
}

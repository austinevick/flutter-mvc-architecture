import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utils.dart';
import '../../model/movie_model.dart';
import '../../model/saved_movie_model.dart';
import '../../service/local_movie_repository_service.dart';
import '../../service/movie_repository_service.dart';

final homeViewNotifier =
    StateNotifierProvider<HomeViewModel, bool>((ref) => HomeViewModel());

class HomeViewModel extends StateNotifier<bool> {
  HomeViewModel() : super(false);
  final ctrl = TextEditingController();

  void setSearchingState() {
    state = !state;
  }

  Future<MovieResponseModel> searchMovieByname(WidgetRef ref) async {
    try {
      return await ref
          .watch(mealRepositoryProvider)
          .searchMovieByTitle(ctrl.text);
    } on SocketException catch (_) {
      showBottomFlash(content: 'No internet connection');
      rethrow;
    } catch (_) {
      showBottomFlash(content: 'Unknown error');
      rethrow;
    }
  }

  Future<int> saveMovie(SavedMovieModel model) async {
    try {
      final result = await LocalMovieRepositoryService.saveMovie(model);
      print(result);
      showBottomFlash(content: 'Movie was successfully saved.', showBtn: true);
      return result;
    } catch (e) {
      showBottomFlash(content: 'Something went wrong');
      rethrow;
    }
  }

  Future<bool> checkIfMovieExist(int id) async {
    final id = await getMovie();
    if (id.contains(id)) {}
    return true;
  }

  Future<List<SavedMovieModel>> getMovie() async {
    return await LocalMovieRepositoryService.getMovies();
  }

  Future<void> deleteMovie(int id) async {
    await LocalMovieRepositoryService.deleteMovie(id);
  }
}

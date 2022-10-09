import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_search_app/controller/movie_collection_controller.dart';
import 'package:movie_search_app/controller/movie_search_history_controller.dart';

import 'controller/movie_remote_repository_controller.dart';

//Home view providers
final saveMovieFutureProvider = FutureProvider(
    (ref) => ref.watch(movieCollectionController.notifier).getSavedMovies());

//Movie detail view providers
final movieExistInCollectionFutureProvider = FutureProvider.family(
    (ref, int id) => ref
        .watch(movieCollectionController.notifier)
        .checkIfMovieExistInDatabase(id));
final tmdbmovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, String id) => ref
        .watch(movieRemoteRepositoryController.notifier)
        .getTMDBMovieDetailsById(id));
final ytsmovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, String id) => ref
        .watch(movieRemoteRepositoryController.notifier)
        .getYTSMovieDetailsById(id));

//Movie search view providers
final searchTMDBMovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, WidgetRef n) => ref
        .watch(movieRemoteRepositoryController.notifier)
        .searchTMDBMoviesByTitle(n));

final searchYTSMovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, WidgetRef n) => ref
        .watch(movieRemoteRepositoryController.notifier)
        .searchYTSMoviesByTitle(n));

final searchedMovieExistFutureProvider = FutureProvider.family((ref, int id) =>
    ref
        .watch(movieSearchHistoryController)
        .checkIfSearchedMovieExistInDatabase(id));

//Explore movies view providers
final ytsMovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, WidgetRef n) =>
        ref.watch(movieRemoteRepositoryController.notifier).getYTSMovies(n));

final tmdbMovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, WidgetRef n) =>
        ref.watch(movieRemoteRepositoryController.notifier).getTMDBMovies(n));

//Search history list provider

final searchedMovieFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(movieSearchHistoryController).getSearchHistory());

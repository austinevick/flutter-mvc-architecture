import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../common/api.dart';
import '../../controller/movie_remote_repository_controller.dart';
import '../../providers.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/movie_error_widget.dart';
import '../../widget/movie_list_widget.dart';
import '../movie_detail_view/tmdb_movie_detail_view.dart';
import '../movie_detail_view/yts_movie_detail_view.dart';
import 'explore_movies_view.dart';

class SearchMovies extends StatelessWidget {
  const SearchMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final movieRepositoryCtrl =
          ref.watch(movieRemoteRepositoryController.notifier);
      final selectedIndex = ref.watch(movieRemoteRepositoryController);
      final notifier = ref.watch(movieRemoteRepositoryController.notifier);
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(70, 70),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 50, right: 16),
              child: CustomTextField(controller: movieRepositoryCtrl.ctrl),
            )),
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 12),
            child: movieRepositoryCtrl.ctrl.text.isEmpty
                ? Container()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildButton('TMDB',
                              () => notifier.setSelectedIndex(0), ref, 0),
                          const SizedBox(width: 10),
                          buildButton('YTS.MX',
                              () => notifier.setSelectedIndex(1), ref, 1)
                        ],
                      ),
                      const SizedBox(height: 8),
                      selectedIndex == 0
                          ? ref.watch(searchTMDBMovieFutureProvider(ref)).when(
                              data: (data) => Expanded(
                                    child: GestureDetector(
                                      onHorizontalDragUpdate: (details) =>
                                          notifier.setSelectedIndex(1),
                                      child: MasonryGridView.count(
                                          itemCount: data.results!.length,
                                          crossAxisCount: 2,
                                          itemBuilder: (ctx, i) =>
                                              MovieListWidget(
                                                image: baseImageUrl +
                                                    data.results![i]
                                                        .posterPath!,
                                                child: TMDBMovieDetailView(
                                                    id: data.results![i].id!),
                                              )),
                                    ),
                                  ),
                              error: (e, t) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 150),
                                      MovieErrorWidget(
                                          onTap: () => ref.refresh(
                                              searchTMDBMovieFutureProvider(
                                                  ref))),
                                    ],
                                  ),
                              loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ))
                          : ref.watch(searchYTSMovieFutureProvider(ref)).when(
                              data: (data) => Expanded(
                                    child: GestureDetector(
                                      onHorizontalDragUpdate: (details) =>
                                          notifier.setSelectedIndex(0),
                                      child: MasonryGridView.count(
                                          itemCount: data.length,
                                          crossAxisCount: 2,
                                          itemBuilder: (ctx, i) =>
                                              MovieListWidget(
                                                  image:
                                                      data[i].largeCoverImage!,
                                                  child: YTSMovieDetailView(
                                                      model: data[i]))),
                                    ),
                                  ),
                              error: (e, t) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 150),
                                      MovieErrorWidget(
                                          onTap: () => ref.refresh(
                                              searchYTSMovieFutureProvider(
                                                  ref))),
                                    ],
                                  ),
                              loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  )),
                      const SizedBox(height: 20),
                    ],
                  )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            ref.refresh(searchTMDBMovieFutureProvider(ref));
            ref.refresh(searchYTSMovieFutureProvider(ref));
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.search, color: Colors.white),
        ),
      );
    });
  }
}

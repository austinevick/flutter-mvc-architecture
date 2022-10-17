import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_search_app/common/api.dart';
import 'package:movie_search_app/controller/movie_remote_repository_controller.dart';
import 'package:movie_search_app/view/explore_movies_view/search_movies_screen.dart';
import 'package:movie_search_app/view/movie_detail_view/tmdb_movie_detail_view.dart';
import 'package:movie_search_app/view/movie_detail_view/yts_movie_detail_view.dart';
import 'package:movie_search_app/widget/movie_error_widget.dart';
import 'package:movie_search_app/widget/movie_list_widget.dart';
import '../../providers.dart';

class ExploreMovieView extends StatelessWidget {
  const ExploreMovieView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final selectedIndex = ref.watch(movieRemoteRepositoryController);
      final notifier = ref.watch(movieRemoteRepositoryController.notifier);
      return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Explore Movies',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => const SearchMovies())),
                          icon: const Icon(Icons.search))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildButton(
                          'TMDB', () => notifier.setSelectedIndex(0), ref, 0),
                      const SizedBox(width: 10),
                      buildButton(
                          'YTS.MX', () => notifier.setSelectedIndex(1), ref, 1)
                    ],
                  ),
                  const SizedBox(height: 20),
                  selectedIndex == 0
                      ? ref.watch(tmdbMovieFutureProvider(ref)).when(
                          data: (data) => GestureDetector(
                                onHorizontalDragUpdate: (details) =>
                                    notifier.setSelectedIndex(1),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: MasonryGridView.count(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: data!.length,
                                      crossAxisCount: 2,
                                      itemBuilder: (ctx, i) => MovieListWidget(
                                            image: baseImageUrl +
                                                data[i].posterPath!,
                                            child: TMDBMovieDetailView(
                                                id: data[i].id!),
                                          )),
                                ),
                              ),
                          error: (e, t) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 150),
                                  MovieErrorWidget(
                                      onTap: () => ref.refresh(
                                          tmdbMovieFutureProvider(ref))),
                                ],
                              ),
                          loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ))
                      : ref.watch(ytsMovieFutureProvider(ref)).when(
                          data: (data) => GestureDetector(
                                onHorizontalDragUpdate: (details) =>
                                    notifier.setSelectedIndex(0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: MasonryGridView.count(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      crossAxisCount: 2,
                                      itemBuilder: (ctx, i) => MovieListWidget(
                                          image: data[i].largeCoverImage!,
                                          child: YTSMovieDetailView(
                                              model: data[i]))),
                                ),
                              ),
                          error: (e, t) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 150),
                                  MovieErrorWidget(
                                      onTap: () => ref.refresh(
                                          ytsMovieFutureProvider(ref))),
                                ],
                              ),
                          loading: () => const Center(
                                child: CircularProgressIndicator(),
                              )),
                ],
              ),
            )),
      );
    });
  }
}

Widget buildButton(String text, VoidCallback onTap, WidgetRef ref, int i) {
  final index = ref.watch(movieRemoteRepositoryController);
  return Expanded(
    child: AnimatedContainer(
      height: 50,
      width: 155,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 3, color: index == i ? Colors.red : Colors.grey))),
      duration: const Duration(milliseconds: 650),
      child: MaterialButton(
        onPressed: onTap,
        padding: const EdgeInsets.all(0),
        child: Text(text),
      ),
    ),
  );
}

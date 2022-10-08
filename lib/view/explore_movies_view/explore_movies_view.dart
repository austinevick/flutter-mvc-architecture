import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_search_app/common/api.dart';
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
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Explore Movies'),
            bottom: const TabBar(tabs: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('TMDB'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('YTS.MX'),
              )
            ]),
          ),
          body: SafeArea(
              child: TabBarView(children: [
            ref.watch(tmdbMovieFutureProvider(ref)).when(
                data: (data) => MasonryGridView.count(
                    itemCount: data!.length,
                    crossAxisCount: 2,
                    itemBuilder: (ctx, i) => MovieListWidget(
                          image: baseImageUrl + data[i].posterPath!,
                          child: TMDBMovieDetailView(id: data[i].id!),
                        )),
                error: (e, t) => MovieErrorWidget(
                    onTap: () => ref.refresh(tmdbMovieFutureProvider(ref))),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    )),
            ref.watch(ytsMovieFutureProvider(ref)).when(
                data: (data) => MasonryGridView.count(
                    itemCount: data.length,
                    crossAxisCount: 2,
                    itemBuilder: (ctx, i) => MovieListWidget(
                        image: data[i].largeCoverImage!,
                        child: YTSMovieDetailView(model: data[i]))),
                error: (e, t) => MovieErrorWidget(
                    onTap: () => ref.refresh(ytsMovieFutureProvider(ref))),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    )),
          ])),
        ),
      );
    });
  }
}

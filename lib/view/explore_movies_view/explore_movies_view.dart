import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_search_app/common/api.dart';
import 'package:movie_search_app/view/movie_detail_view/tmdb_movie_detail_view.dart';
import 'package:movie_search_app/view/movie_detail_view/yts_movie_detail_view.dart';

import 'explore_movies_view_model.dart';

final ytsMovieFutureProvider = FutureProvider.family(
    (ref, WidgetRef n) => ref.watch(exploreMoviesViewNotifier).getYTSMovies(n));

final tmdbMovieFutureProvider = FutureProvider.family((ref, WidgetRef n) =>
    ref.watch(exploreMoviesViewNotifier).getTMDBMovies(n));

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
                    itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      TMDBMovieDetailView(id: data[i].id!))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                  child:
                                      SpinKitDoubleBounce(color: Colors.grey)),
                              fit: BoxFit.cover,
                              imageUrl: baseImageUrl + data[i].posterPath!,
                            ),
                          ),
                        ))),
                error: (e, t) => const Center(
                      child: Text('Something went wrong'),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    )),
            ref.watch(ytsMovieFutureProvider(ref)).when(
                data: (data) => MasonryGridView.count(
                    itemCount: data.length,
                    crossAxisCount: 2,
                    itemBuilder: (ctx, i) => MaterialButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      YTSMovieDetailView(model: data[i]))),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                      child: SpinKitDoubleBounce(
                                          color: Colors.grey)),
                                  fit: BoxFit.cover,
                                  imageUrl: data[i].largeCoverImage!,
                                ),
                              )),
                        )),
                error: (e, t) => const Center(
                      child: Text('Something went wrong'),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    )),
          ])),
        ),
      );
    });
  }
}

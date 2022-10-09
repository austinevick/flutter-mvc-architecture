import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:movie_search_app/widget/movie_list_widget.dart';
import '../../common/api.dart';
import '../../common/utils.dart';
import '../../providers.dart';
import '../movie_detail_view/tmdb_movie_detail_view.dart';
import '../movie_search_view/movie_search_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff1d2127),
          title: const Text('My Movie Collections'),
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(0),
            child: ref.watch(saveMovieFutureProvider).when(
                data: (data) => data.isEmpty
                    ? Center(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(emptyViewText,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800),
                                textAlign: TextAlign.center)))
                    : MasonryGridView.count(
                        itemCount: data.length,
                        crossAxisCount: 2,
                        itemBuilder: (ctx, i) => MovieListWidget(
                            image: baseImageUrl + data[i].image!,
                            child: TMDBMovieDetailView(id: data[i].movieId!))),
                error: (e, t) => const SizedBox.shrink(),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showMaterialModalBottomSheet(
              enableDrag: false,
              context: context,
              builder: (ctx) => const MovieSearchView()),
          backgroundColor: Colors.red,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    });
  }
}

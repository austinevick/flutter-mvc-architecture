import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/controller/movie_search_history_controller.dart';
import '../common/api.dart';
import '../providers.dart';
import '../view/movie_detail_view/tmdb_movie_detail_view.dart';

class SearchHistoryList extends ConsumerWidget {
  const SearchHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(searchedMovieFutureProvider).when(
        data: (data) => Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent searches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, i) => ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => TMDBMovieDetailView(
                                        id: data[i].movieId!)));
                              },
                              contentPadding: const EdgeInsets.only(top: 8),
                              title: Text(data[i].title!),
                              trailing: IconButton(
                                  onPressed: () => ref
                                      .read(movieSearchHistoryController)
                                      .deleteSearchMovie(ref, data[i].id!),
                                  icon: const Icon(Icons.clear)),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  alignment: Alignment.topCenter,
                                  placeholder: (context, url) => const Center(
                                      child: SpinKitDoubleBounce(
                                          color: Colors.grey)),
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                  imageUrl: baseImageUrl + data[i].image!,
                                  errorWidget: ((context, url, error) =>
                                      Container()),
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
        error: (e, t) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}

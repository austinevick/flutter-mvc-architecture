import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/view/search_history_view/search_history_view_model.dart';

import '../common/api.dart';

final searchedMovieFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(searchHistoryViewNotifier).getSearchHistory());

class SearchHistoryList extends ConsumerWidget {
  const SearchHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(searchedMovieFutureProvider).when(
        data: (data) => Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, i) => ListTile(
                        contentPadding: EdgeInsets.only(top: 8),
                        title: Text(data[i].title!),
                        trailing: IconButton(
                            onPressed: () => ref
                                .read(searchHistoryViewNotifier)
                                .deleteSearchMovie(data[i].id!),
                            icon: const Icon(Icons.clear)),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            alignment: Alignment.topCenter,
                            placeholder: (context, url) => const Center(
                                child: SpinKitDoubleBounce(color: Colors.grey)),
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                            imageUrl: baseImageUrl + data[i].image!,
                            errorWidget: ((context, url, error) => Container()),
                          ),
                        ),
                      )),
            ),
        error: (e, t) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}

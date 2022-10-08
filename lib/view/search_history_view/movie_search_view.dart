import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/controller/movie_remote_repository_controller.dart';
import 'package:movie_search_app/controller/movie_search_history_controller.dart';
import 'package:movie_search_app/view/movie_detail_view/tmdb_movie_detail_view.dart';
import 'package:movie_search_app/widget/custom_textfield.dart';
import 'package:movie_search_app/widget/movie_error_widget.dart';
import 'package:movie_search_app/widget/search_history_list.dart';
import '../../common/api.dart';
import '../../providers.dart';

class MovieSearchView extends StatelessWidget {
  const MovieSearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final movieRepositoryCtrl = ref.watch(movieRemoteRepositoryController);
      final movieHistoryCtrl = ref.watch(movieSearchHistoryController);
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(60, 60),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 50, right: 16),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.keyboard_backspace, size: 32)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: CustomTextField(
                    controller: movieRepositoryCtrl.ctrl,
                  )),
                ],
              ),
            )),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: movieRepositoryCtrl.ctrl.text.isEmpty
              ? const SearchHistoryList()
              : ref.watch(searchMovieFutureProvider(ref)).when(
                  data: (data) => data.results == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              itemCount: data.results!.length,
                              itemBuilder: (ctx, i) => ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      movieHistoryCtrl
                                          .saveSearchHistory(data.results![i]);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  TMDBMovieDetailView(
                                                      id: data
                                                          .results![i].id!)));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        alignment: Alignment.topCenter,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child: SpinKitDoubleBounce(
                                                    color: Colors.grey)),
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                        imageUrl: baseImageUrl +
                                            data.results![i].posterPath!,
                                        errorWidget: ((context, url, error) =>
                                            Container()),
                                      ),
                                    ),
                                    title: Text(data.results![i].title!),
                                    trailing:
                                        const Icon(Icons.keyboard_arrow_right),
                                  )),
                        ),
                  error: (e, t) => Center(
                        child: MovieErrorWidget(
                            onTap: () =>
                                ref.refresh(searchMovieFutureProvider(ref))),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            ref.refresh(searchMovieFutureProvider(ref));
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.search, color: Colors.white),
        ),
      );
    });
  }
}

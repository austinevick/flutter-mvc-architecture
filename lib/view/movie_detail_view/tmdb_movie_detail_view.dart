import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/controller/movie_collection_controller.dart';
import 'package:movie_search_app/controller/movie_remote_repository_controller.dart';
import 'package:movie_search_app/model/tmdb_movie_model.dart';
import 'package:movie_search_app/providers.dart';
import 'package:movie_search_app/widget/button_loader.dart';
import 'package:movie_search_app/widget/movie_error_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/api.dart';
import '../../widget/custom_button.dart';

class TMDBMovieDetailView extends StatelessWidget {
  final int id;
  const TMDBMovieDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(movieRemoteRepositoryController.notifier).ref = ref;
      ref.watch(movieCollectionController.notifier).getSavedMovieId(id);
      bool isLoading = ref.watch(movieCollectionController);

      final n = ref.watch(movieCollectionController.notifier);
      return Scaffold(
          body: ref.watch(tmdbmovieFutureProvider(id.toString())).when(
              data: (data) => Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.8),
                          Colors.black,
                          Colors.black,
                          Colors.black,
                        ])),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            alignment: Alignment.topCenter,
                            placeholder: (context, url) => const Center(
                                child: SpinKitDoubleBounce(color: Colors.grey)),
                            fit: BoxFit.cover,
                            imageUrl: baseImageUrl + data.posterPath!,
                            errorWidget: ((context, url, error) => Container()),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.overview!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data.releaseDate!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildButton(ref, isLoading, n, data),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
              error: (e, t) => Center(
                    child: MovieErrorWidget(
                        onTap: () => ref
                            .refresh(tmdbmovieFutureProvider(id.toString()))),
                  ),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }

  Widget buildButton(WidgetRef ref, bool isLoading, MovieCollectionController n,
      TMDBMovieResponseData data) {
    return ref.watch(movieExistInCollectionFutureProvider(id)).when(
        data: (isExist) => !isExist
            ? CustomButton(
                radius: 16,
                color: Colors.red,
                child:
                    ButtonLoader(isLoading: isLoading, text: 'Save to device'),
                onPressed: () => n.saveMovieToDevice(ref, data),
              )
            : CustomButton(
                radius: 16,
                color: Colors.red,
                child: ButtonLoader(
                    isLoading: isLoading, text: 'Remove from device'),
                onPressed: () => n.removeSavedMovie(ref, data),
              ),
        error: (e, t) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}

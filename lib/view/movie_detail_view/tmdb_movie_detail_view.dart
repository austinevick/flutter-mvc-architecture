import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/controller/movie_collection_controller.dart';
import 'package:movie_search_app/controller/movie_remote_repository_controller.dart';
import 'package:movie_search_app/providers.dart';
import 'package:movie_search_app/widget/button_loader.dart';
import '../../common/api.dart';
import '../../widget/custom_button.dart';

class TMDBMovieDetailView extends StatelessWidget {
  final int id;
  const TMDBMovieDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(movieRemoteRepositoryController).ref = ref;
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
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              CachedNetworkImage(
                                alignment: Alignment.topCenter,
                                placeholder: (context, url) => const Center(
                                    child: SpinKitDoubleBounce(
                                        color: Colors.grey)),
                                fit: BoxFit.cover,
                                imageUrl: baseImageUrl + data.posterPath!,
                                errorWidget: ((context, url, error) =>
                                    Container()),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Overview',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(data.overview!),
                                      CustomButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: const [
                                            Text('View in browser'),
                                            Icon(Icons.keyboard_arrow_right)
                                          ],
                                        ),
                                      ),
                                      ref
                                          .watch(
                                              movieExistInCollectionFutureProvider(
                                                  id))
                                          .when(
                                              data: (isExist) => !isExist
                                                  ? CustomButton(
                                                      radius: 16,
                                                      color: Colors.red,
                                                      child: ButtonLoader(
                                                          isLoading: isLoading,
                                                          text:
                                                              'Save to device'),
                                                      onPressed: () =>
                                                          n.saveMovieToDevice(
                                                              ref, data),
                                                    )
                                                  : CustomButton(
                                                      radius: 16,
                                                      color: Colors.red,
                                                      child: ButtonLoader(
                                                          isLoading: isLoading,
                                                          text:
                                                              'Remove from device'),
                                                      onPressed: () =>
                                                          n.removeSavedMovie(
                                                              ref, data),
                                                    ),
                                              error: (e, t) =>
                                                  const SizedBox.shrink(),
                                              loading: () =>
                                                  const SizedBox.shrink())
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              error: (e, t) => const Center(
                    child: Text('Something went wrong'),
                  ),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}

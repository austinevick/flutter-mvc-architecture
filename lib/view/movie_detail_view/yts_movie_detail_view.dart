import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/controller/movie_remote_repository_controller.dart';
import 'package:movie_search_app/model/yts_movie_model.dart';

class YTSMovieDetailView extends StatelessWidget {
  final YTSMoviesResponseModel model;
  const YTSMovieDetailView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(movieRemoteRepositoryController).ref = ref;

      return Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: CachedNetworkImage(
                alignment: Alignment.topCenter,
                placeholder: (context, url) => const Center(
                    child: SpinKitDoubleBounce(color: Colors.grey)),
                fit: BoxFit.cover,
                imageUrl: model.largeCoverImage!,
                errorWidget: ((context, url, error) => Container()),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        model.title!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Text(model.year.toString()),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Overview',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                      Text(model.summary!),
                      const Spacer(),
                      // ref.watch(movieIdFutureProvider(model.id!)).when(
                      //     data: (data) => !data
                      //         ? CustomButton(
                      //             radius: 16,
                      //             color: Colors.red,
                      //             text: 'Save to device',
                      //             onPressed: () => n.saveMovie(ref, model),
                      //           )
                      //         : CustomButton(
                      //             radius: 16,
                      //             color: Colors.red,
                      //             child: ButtonLoader(
                      //                 isLoading: isLoading,
                      //                 text: 'Remove from device'),
                      //             onPressed: () =>
                      //                 n.removeSavedMovie(ref, model),
                      //           ),
                      //     error: (e, t) => const SizedBox.shrink(),
                      //     loading: () => const SizedBox.shrink())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

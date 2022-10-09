import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_search_app/controller/movie_remote_repository_controller.dart';
import 'package:movie_search_app/model/yts_movie_model.dart';
import 'package:movie_search_app/widget/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class YTSMovieDetailView extends StatelessWidget {
  final YTSMoviesResponseModel model;
  const YTSMovieDetailView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(movieRemoteRepositoryController.notifier).ref = ref;

      return Scaffold(
        body: Container(
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
                  imageUrl: model.largeCoverImage!,
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
                            model.summary!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            model.year.toString(),
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
                  child: CustomButton(
                    radius: 16,
                    color: Colors.red,
                    onPressed: () => launchUrl(Uri.parse(model.url!),
                        mode: LaunchMode.externalApplication),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('View in browser'),
                        SizedBox(width: 6),
                        Icon(Icons.launch),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../common/api.dart';
import '../../model/movie_model.dart';
import '../../model/saved_movie_model.dart';
import '../../widget/custom_button.dart';
import 'home_view_model.dart';
import 'saved_movie_view.dart';

class MovieDetailView extends StatelessWidget {
  final Results model;
  const MovieDetailView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final n = ref.watch(homeViewNotifier.notifier);
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
                imageUrl: baseImageUrl + model.posterPath!,
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
                      Text(model.releaseDate!),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Overview',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                      Text(model.overview!),
                      Spacer(),
                      CustomButton(
                        radius: 16,
                        color: Colors.red,
                        text: 'Save to device',
                        onPressed: () {
                          final movie = SavedMovieModel(
                              title: model.title,
                              overview: model.overview,
                              image: baseImageUrl + model.posterPath!);
                          print(movie);
                          n.saveMovie(movie);
                          ref.refresh(saveMovieFutureProvider);
                        },
                      )
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

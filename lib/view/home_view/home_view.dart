import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../common/api.dart';
import 'home_view_model.dart';

final saveMovieFutureProvider = FutureProvider(
    (ref) => ref.watch(homeViewNotifier.notifier).getSavedMovies());

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final n = ref.watch(homeViewNotifier.notifier);
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff1d2127),
            title: const Text('Saved Movies'),
          ),
          body: SafeArea(
              minimum: const EdgeInsets.all(0),
              child: ref.watch(saveMovieFutureProvider).when(
                  data: (data) => data.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              n.emptyViewText,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : MasonryGridView.count(
                          itemCount: data.length,
                          crossAxisCount: 2,
                          itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                      child: SpinKitDoubleBounce(
                                          color: Colors.grey)),
                                  fit: BoxFit.cover,
                                  imageUrl: baseImageUrl + data[i].image!,
                                ),
                              ))),
                  error: (e, t) => const Center(
                        child: Text('Something went wrong'),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ))));
    });
  }
}

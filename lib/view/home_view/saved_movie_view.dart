import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../common/api.dart';
import '../../widget/custom_button.dart';
import 'home_view_model.dart';

final saveMovieFutureProvider =
    FutureProvider((ref) => ref.watch(homeViewNotifier.notifier).getMovie());

class SavedMovieView extends StatefulWidget {
  const SavedMovieView({super.key});

  @override
  State<SavedMovieView> createState() => _SavedMovieViewState();
}

class _SavedMovieViewState extends State<SavedMovieView> {
  // final crtl = PageController(viewportFraction: 0.8);

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (widget.page == null) return;
  //     crtl.animateToPage(widget.page!,
  //         duration: const Duration(seconds: 2), curve: Curves.easeIn);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
          body: ref.watch(saveMovieFutureProvider).when(
              data: (data) => data.isEmpty
                  ? const Center(
                      child: Text('No data'),
                    )
                  : PageView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                      child: SpinKitDoubleBounce(
                                          color: Colors.grey)),
                                  fit: BoxFit.cover,
                                  imageUrl: baseImageUrl + data[i].image!,
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data[i].title!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data[i].overview!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const Spacer(),
                                CustomButton(
                                  radius: 16,
                                  color: Colors.red,
                                  text: 'Remove from device',
                                  onPressed: () {
                                    ref
                                        .read(homeViewNotifier.notifier)
                                        .deleteMovie(data[i].id!);
                                    ref.refresh(saveMovieFutureProvider);
                                  },
                                )
                              ],
                            ),
                          )),
              error: (error, trace) => const SizedBox(),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}

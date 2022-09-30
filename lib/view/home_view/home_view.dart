import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_view_model.dart';
import 'movie_detail_view.dart';
import 'saved_movie_view.dart';

final movieFutureProvider = FutureProvider.family((ref, WidgetRef n) =>
    ref.watch(homeViewNotifier.notifier).searchMovieByname(n));

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final n = ref.watch(homeViewNotifier.notifier);
      final isSearching = ref.watch(homeViewNotifier);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: isSearching
              ? TextField(
                  controller: n.ctrl,
                  cursorColor: Colors.white,
                  cursorWidth: 1,
                  autofocus: true,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search movies here'),
                )
              : const Text('Movie'),
          actions: [
            IconButton(
                onPressed: () => n.setSearchingState(),
                icon: Icon(isSearching ? Icons.clear : Icons.search)),
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const SavedMovieView())),
                icon: const Icon(Icons.download))
          ],
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                    child: ref.watch(movieFutureProvider(ref)).when(
                        data: (data) => data.results == null
                            ? const Center(
                                child: Text('No movies to display'),
                              )
                            : ListView.builder(
                                itemCount: data.results!.length,
                                itemBuilder: (ctx, i) => ListTile(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => MovieDetailView(
                                                  model: data.results![i]))),
                                      title: Text(data.results![i].title!),
                                      trailing: const Icon(
                                          Icons.keyboard_arrow_right),
                                    )),
                        error: (e, t) => const Center(
                              child: Text('Something went wrong'),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            )))
              ],
            )),
        floatingActionButton: isSearching
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(Icons.search, color: Colors.white),
                onPressed: () => ref.refresh(movieFutureProvider(ref)))
            : null,
      );
    });
  }
}

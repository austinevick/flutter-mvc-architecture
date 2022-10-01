import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_search_app/view/search_history_view/search_history_view_model.dart';
import 'package:movie_search_app/widget/custom_textfield.dart';
import 'package:movie_search_app/widget/search_history_list.dart';

import '../home_view/movie_detail_view.dart';

final searchMovieFutureProvider = FutureProvider.family.autoDispose(
    (ref, WidgetRef n) =>
        ref.watch(searchHistoryViewNotifier).searchMovieByName(n));

final searchHistoryFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(searchHistoryViewNotifier).getSearchHistory());

class MovieSearchView extends StatelessWidget {
  const MovieSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final n = ref.watch(searchHistoryViewNotifier);
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
                    controller: n.ctrl,
                  )),
                ],
              ),
            )),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: n.ctrl.text.isEmpty
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
                                      n.saveSearchHistory(data.results![i]);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => MovieDetailView(
                                                  model: data.results![i])));
                                    },
                                    title: Text(data.results![i].title!),
                                    trailing:
                                        const Icon(Icons.keyboard_arrow_right),
                                  )),
                        ),
                  error: (e, t) => const Center(
                        child: Text('Something went wrong'),
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

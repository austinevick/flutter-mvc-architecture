import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:movie_search_app/view/explore_movies_view/explore_movies_view.dart';
import 'package:movie_search_app/view/home_view/home_view.dart';
import 'package:movie_search_app/view/search_history_view/movie_search_view.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  final screens = [const HomeView(), const ExploreMovieView()];
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[i],
      floatingActionButton: FloatingActionButton(
        onPressed: () => showMaterialModalBottomSheet(
            enableDrag: false,
            context: context,
            builder: (ctx) => const MovieSearchView()),
        backgroundColor: Colors.red,
        child: const Icon(Icons.search, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [Icons.home, Icons.explore],
        activeIndex: i,
        height: 70,
        activeColor: Colors.white,
        iconSize: 35,
        inactiveColor: Colors.grey,
        splashColor: null,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 10,
        backgroundColor: Colors.black,
        rightCornerRadius: 10,
        onTap: (index) => setState(() => i = index),
      ),
    );
  }
}

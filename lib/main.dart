import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_search_app/view/bottom_navigation_view.dart';
import 'common/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  hasInternetConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Bank',
        theme: ThemeData.dark(),
        home: const BottomNavigationView(),
        navigatorKey: navigatorkey,
      ),
    );
  }
}

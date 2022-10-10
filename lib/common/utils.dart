import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

final navigatorkey = GlobalKey<NavigatorState>();

void hasInternetConnection() {
  Connectivity().onConnectivityChanged.listen((event) {
    if (event == ConnectivityResult.none) {
      showDialogFlash();
    }
  });
}

void showBottomFlash({String? title, String? content}) {
  showFlash(
    context: navigatorkey.currentContext!,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        margin: const EdgeInsets.all(10),
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        borderRadius: BorderRadius.circular(8.0),
        forwardAnimationCurve: Curves.easeInCirc,
        backgroundColor: Colors.black,
        reverseAnimationCurve: Curves.easeIn,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: FlashBar(
            title: Text(title ?? ''),
            content: Text(
              content ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => controller.dismiss(),
                  child: const Text('DISMISS')),
            ],
          ),
        ),
      );
    },
  );
}

void showDialogFlash() {
  navigatorkey.currentContext!.showFlashDialog(
      constraints: const BoxConstraints(maxWidth: 300),
      title: const Text('Internet connection', style: TextStyle(fontSize: 16)),
      content: const Text(
          'You are currently offline, turn on your mobile data or wifi to connect.',
          style: TextStyle(fontSize: 14)),
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
            onPressed: () => controller.dismiss(), child: const Text('OK'));
      });
}

const noConnection = 'No internet connection';
const somethingwentwrong = 'Something went wrong';
String emptyViewText =
    "No movie collection\nBegin by clicking the + button to search and save your favorite movies here.";

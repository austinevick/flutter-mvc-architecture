import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

final navigatorkey = GlobalKey<NavigatorState>();

void showBottomFlash(
    {String? title, String? content, bool showBtn = false, int? page}) {
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
              showBtn
                  ? TextButton(
                      onPressed: () {
                        // Navigator.of(navigatorkey.currentContext!).push(
                        //     MaterialPageRoute(
                        //         builder: (ctx) => SavedMovieView(page: page)));
                        controller.dismiss();
                      },
                      child: const Text('SHOW'))
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    },
  );
}

const noConnection = 'No internet connection';
const somethingwentwrong = 'Something went wrong';

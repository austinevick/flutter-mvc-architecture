import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovieListWidget extends StatelessWidget {
  final String image;
  final Widget child;
  const MovieListWidget({super.key, required this.image, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => child)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => Container(),
              placeholder: (context, url) =>
                  const Center(child: SpinKitDoubleBounce(color: Colors.grey)),
              fit: BoxFit.cover,
              imageUrl: image,
            ),
          ),
        ));
  }
}

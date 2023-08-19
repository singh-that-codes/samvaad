import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;

  final BoxFit fit;

  String name;
  final String noImageAvailable =
      "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  CachedImage(
    this.imageUrl, {
    this.isRound = false,
    this.radius = 0,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
    this.name = '',
  });

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(isRound ? 50 : radius),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                child: Row(
                  children: [
                    Icon(Icons.file_copy),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(child: Text(name)),
                  ],
                ),
              ),
              //     Image.network(
              //   noImageAvailable,
              //   height: 25,
              //   width: 25,
              //   fit: BoxFit.cover,
              // ),
            )),
      );
    } catch (e) {
      print(e);
      return Image.network(
        noImageAvailable,
        height: 25,
        width: 25,
        fit: BoxFit.cover,
      );
    }
  }
}

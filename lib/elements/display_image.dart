import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';

class DisplayImage extends StatelessWidget {
  final String imageLink;
  final String uid;
  final double widthImage;
  final double heightImage;

  const DisplayImage({
    super.key,
    required this.imageLink,
    required this.uid,
    required this.widthImage,
    required this.heightImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoOpen(
              path: imageLink,
              uid: uid,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        height: heightImage,
        width: widthImage,
        /*height: kIsWeb
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width - 32,
        width: kIsWeb
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width - 32,*/
        child: Image.network(
          imageLink,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Center(
              child: Icon(Icons.error),
            );
          },
        ),
      ),
    );
  }
}
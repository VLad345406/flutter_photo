import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';

class DisplayImageInProfile extends StatelessWidget {
  final String imageLink;
  final String uid;

  const DisplayImageInProfile(
      {super.key, required this.imageLink, required this.uid});

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
        height: MediaQuery.of(context).size.width - 32,
        width: MediaQuery.of(context).size.width - 32,
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

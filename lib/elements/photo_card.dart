import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/main/photo_open.dart';

class PhotoCard extends StatelessWidget {
  final String pathImage;

  const PhotoCard({super.key, required this.pathImage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth - 32,
      margin: const EdgeInsets.only(
        left: 16,
        top: 24,
        right: 16,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoOpen(
                    path: pathImage,
                  ),
                ),
              );
            },
            child: Container(
              height: screenWidth - 32,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(pathImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/images/user.png'),
          ),
        ],
      ),
    );
  }
}

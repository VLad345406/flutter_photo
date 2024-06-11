import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/photo_card.dart';

class DisplayPictures extends StatelessWidget {
  final List<Map<String, dynamic>> searchResult;

  const DisplayPictures({
    super.key,
    required this.searchResult,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: searchResult.length,
      itemBuilder: (BuildContext context, int index) {
        final userPicture = searchResult[index];
        final imageLink = userPicture.values.first;
        final uid = userPicture.keys.first;
        return PhotoCard(
          pathImage: imageLink,
          cardWidth: MediaQuery.of(context).size.width,
          uid: uid,
        );
      },
    );
  }
}

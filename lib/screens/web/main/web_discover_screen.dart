import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/photo_card.dart';
import 'package:google_fonts/google_fonts.dart';

class WebDiscoverScreen extends StatefulWidget {
  const WebDiscoverScreen({super.key});

  @override
  State<WebDiscoverScreen> createState() => _WebDiscoverScreenState();
}

class _WebDiscoverScreenState extends State<WebDiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text(
              'Discover',
              style: GoogleFonts.comfortaa(
                fontSize: 90,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          PhotoCard(
            pathImage: 'assets/images/start_background_mobile.jpg',
            cardWidth: 400,
            uid: '',
          ),
          PhotoCard(
            pathImage: 'assets/images/Profile1/picture1.jpg',
            cardWidth: 400,
            uid: '',
          ),
          PhotoCard(
            pathImage: 'assets/images/Profile1/picture1.jpg',
            cardWidth: 400,
            uid: '',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/photo_card.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;

    //final widthButton = screenWidth - 32;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Discover',
          style: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          PhotoCard(
            pathImage: 'assets/images/start_background.jpg',
          ),
          PhotoCard(
            pathImage: 'assets/images/Profile1/picture1.jpg',
          ),
        ],
      ),
      /*body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
           if (index == 0) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, top: 32),
                      child: Text(
                        "WHAT'S NEW TODAY",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth - 32 + 16 + 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return PhotoCard(
                          pathImage: 'assets/images/start_background.jpg',
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, top: 48),
                      child: Text(
                        'BROWSE ALL',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
          return PhotoCard(
            pathImage: 'assets/images/start_background.jpg',
          );
          }
        },
      ),*/
    );
  }
}

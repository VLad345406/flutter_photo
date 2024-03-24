import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search',
          style: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth - 32,
            height: 52,
            margin: const EdgeInsets.only(left: 16, top: 32),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
                top: 14,
              ),
              child: TextField(
                //obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Search all photos',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class WebSearchScreen extends StatefulWidget {
  const WebSearchScreen({super.key});

  @override
  State<WebSearchScreen> createState() => _WebSearchScreenState();
}

class _WebSearchScreenState extends State<WebSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text(
              'Search',
              style: GoogleFonts.comfortaa(
                fontSize: 90,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 50,
              right: 50,
            ),
            child: PhotoTextField(
              controller: searchController,
              showVisibleButton: false,
              label: 'Search all photos, profiles',
              disableSpace: false,
              disableUppercase: false,
            ),
          ),
        ],
      ),
    );
  }
}

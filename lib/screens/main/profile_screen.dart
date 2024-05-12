import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/screens/main/edit_profile_screen.dart';
import 'package:flutter_qualification_work/screens/main/photo_open.dart';
import 'package:flutter_qualification_work/screens/main/profile_header_builder.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final String mode;

  const ProfileScreen({Key? key, required this.mode}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<String> photoArray = [
      "picture1.jpg",
      "picture2.jpg",
      "picture3.jpg",
      "picture4.jpg",
      "picture5.jpg",
      "picture5.jpg"
    ];
    int _countPictures = 5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tom',
          style: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        //itemCount: photoArray.length + 2,
        itemCount: photoArray.length > 5
            ? (_countPictures + 2)
            : (photoArray.length + 2),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ProfileHeaderBuilder(mode: widget.mode);
          } else if (index < photoArray.length + 1 &&
              index < _countPictures + 1) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotoOpen(
                            path:
                                'assets/images/Profile1/${photoArray[index - 1]}')));
              },
              /*onTap: (){
                //Navigator.pushNamed(context, '/photo_open');
                // PhotoOpen(path: 'assets/images/Profile1/${photoArray[index - 1]}');
                Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoOpen(path: 'assets/images/Profile1/${photoArray[index - 1]}')));
              },*/
              child: Container(
                margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
                height: screenWidth - 32,
                width: screenWidth - 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Profile1/${photoArray[index - 1]}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          } else if (photoArray.length > 5) {
            return PhotoButton(
              widthButton: screenWidth - 32,
              buttonMargin: const EdgeInsets.only(top: 32, left: 16, right: 16),
              buttonText: 'SEE MORE',
              textColor: Colors.black,
              buttonColor: Colors.white,
            );
          }
          return null;
        },
      ),
    );
  }
}

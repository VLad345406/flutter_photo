import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class PhotoOpen extends StatefulWidget {
  final String path;

  const PhotoOpen({Key? key, required this.path}) : super(key: key);

  @override
  State<PhotoOpen> createState() => _PhotoOpenState();
}

class _PhotoOpenState extends State<PhotoOpen> {
  @override
  Widget build(BuildContext context) {
    //get screen ppi

    //final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        fit: StackFit.loose,
        children: [
          PhotoView(
            minScale: 0.18,
            maxScale: 1.0,
            imageProvider: AssetImage(widget.path),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: const EdgeInsets.only(top: 46, left: 16),
                child: Image.asset('assets/images/user.png')),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(top: 40, right: 16),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

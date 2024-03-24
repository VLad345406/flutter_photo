import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
          'Edit profile',
          style: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'CHANGE AVATAR',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () {
                      print("Change avatar");
                    },
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage("assets/images/avatar1.jpg"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Name',
                  style: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) {
                    //_passwd = _readTextFormField(value);
                  },
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Nick name',
                  style: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) {
                    //_passwd = _readTextFormField(value);
                  },
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Email',
                  style: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) {
                    //_passwd = _readTextFormField(value);
                  },
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Password',
                  style: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) {
                    //_passwd = _readTextFormField(value);
                  },
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'New password',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) {
                    //_passwd = _readTextFormField(value);
                  },
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth - 32,
                height: 52,
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'SAVE',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    print("Delete account");
                  },
                  child: Text(
                    'Delete account',
                    style: GoogleFonts.comfortaa(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

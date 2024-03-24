import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/main/profile_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final int index;

  const ChatScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> user1Messages = [
      "Really love your most recent photo. I’ve been trying to capture the same thing for a few months and would love some tips!",
      "Thank you! That was very helpful!",
      "A fast 50mm like f1.8 would help with the bokeh. I’ve been using primes as they tend to get a bit sharper images.",
      "Thanks!"
    ];

    final List<String> users = [
      "Tom",
      "Alice",
      "Sam",
      "Bob",
      "Kate",
      "Tom",
      "Alice",
      "Sam",
      "Bob",
      "Kate",
      "Tom",
      "Alice",
      "Sam",
      "Bob",
      "Kate"
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shape: Border(
            bottom: BorderSide(
                color: Colors.grey,
                width: 1
            )
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
          ),
        ),
        elevation: 0,
        title: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ProfileScreen( mode: 'other',)));
          },
          child: Text(
            users[widget.index],
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              //color: Colors.black,
              child: ListView.builder(
                itemCount: user1Messages.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0 || index % 2 != 0){
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 16),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage("assets/images/avatar1.jpg"),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.grey[300],
                              child: Text(
                                  user1Messages[index]
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else{
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.grey[300],
                              child: Text(
                                  user1Messages[index]
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage("assets/images/avatar1.jpg"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
                height: 82,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(screenWidth - 90, 52)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Write message',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2)
                      ),
                    ),
                  ),
                ),
              ),

              IconButton(onPressed: (){}, icon: Icon(Icons.send, size: 30,)),
            ],
          ),
        ],
      ),
    );
  }
}

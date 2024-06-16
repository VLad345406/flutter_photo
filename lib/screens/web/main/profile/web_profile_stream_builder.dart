import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qualification_work/elements/audio_player.dart';
import 'package:flutter_qualification_work/elements/display_image.dart';
import 'package:flutter_qualification_work/elements/display_video.dart';
import 'package:flutter_qualification_work/services/remove_picture_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';

class WebProfileStreamBuilder extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  final String userId;
  final String userName;
  final String mode;

  const WebProfileStreamBuilder({
    super.key,
    required this.stream,
    required this.userId,
    required this.userName,
    required this.mode,
  });

  @override
  State<WebProfileStreamBuilder> createState() =>
      _WebProfileStreamBuilderState();
}

class _WebProfileStreamBuilderState extends State<WebProfileStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            return Center(child: Text('Error ${snapshot.error.toString()}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }
          if (snapshot.data!.docs.length == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                "You haven't uploaded any images yet!",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.width /
                  2 *
                  snapshot.data!.docs.length,
              child: Align(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final userFile = snapshot.data!.docs[index];
                    final imageLink = userFile['file_link'];

                    return Stack(
                      alignment: AlignmentDirectional.topEnd,
                      fit: StackFit.loose,
                      children: [
                        userFile['file_type'] == 'image'
                            ? Center(
                                child: DisplayImage(
                                  imageLink: imageLink,
                                  uid: widget.userId,
                                  widthImage:
                                      MediaQuery.of(context).size.width / 2,
                                  heightImage:
                                      MediaQuery.of(context).size.width / 2,
                                ),
                              )
                            : userFile['file_type'] == 'music'
                                ? Center(
                                    child: AudioPlayerWidget(
                                      fileName: userFile['file_name'],
                                      fileLink: userFile['file_link'],
                                      playerWidth:
                                          MediaQuery.of(context).size.width / 2,
                                      playerHeight:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                  )
                                : DisplayVideo(
                                    fileName: userFile['file_name'],
                                    fileLink: userFile['file_link'],
                                    videoWidth:
                                        MediaQuery.of(context).size.width / 2,
                                    videoHeight:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                        widget.mode == 'personal'
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  right: MediaQuery.of(context).size.width / 4 -
                                      40,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    String result = await removePictureService(
                                      'content/${widget.userName}/${userFile['file_name']}',
                                      userFile['file_name'],
                                    );
                                    if (result == 'Success') {
                                      context
                                          .read<ProfileBloc>()
                                          .add(LoadUserData());
                                      snackBar(context, 'Success remove file!');
                                    } else {
                                      snackBar(context, 'Fail remove file!');
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        } catch (e) {
          return Text(
            "You haven't uploaded any images yet!",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 20,
            ),
          );
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qualification_work/elements/audio_player.dart';
import 'package:flutter_qualification_work/elements/display_image.dart';
import 'package:flutter_qualification_work/elements/video_player.dart';
import 'package:flutter_qualification_work/services/remove_picture_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';

class ProfileStreamBuilder extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  final String userId;
  final String userName;
  final String mode;

  const ProfileStreamBuilder({
    super.key,
    required this.stream,
    required this.userId,
    required this.userName,
    required this.mode,
  });

  @override
  State<ProfileStreamBuilder> createState() => _ProfileStreamBuilderState();
}

class _ProfileStreamBuilderState extends State<ProfileStreamBuilder> {
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
              height: MediaQuery.of(context).size.width *
                  snapshot.data!.docs.length,
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
                          ? DisplayImage(
                              imageLink: imageLink,
                              uid: widget.userId,
                              widthImage: kIsWeb
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width - 32,
                              heightImage: kIsWeb
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width - 32,
                            )
                          : userFile['file_type'] == 'music'
                              ? AudioPlayerWidget(
                                  fileName: userFile['file_name'],
                                  fileLink: userFile['file_link'],
                                  playerWidth: kIsWeb
                                      ? MediaQuery.of(context).size.width / 2
                                      : MediaQuery.of(context).size.width - 32,
                                  playerHeight: kIsWeb
                                      ? MediaQuery.of(context).size.width / 2
                                      : MediaQuery.of(context).size.width - 32,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          fileName: userFile['file_name'],
                                          fileLink: userFile['file_link'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16, top: 16),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            userFile['file_name'],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      widget.mode == 'personal'
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                right: 16,
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

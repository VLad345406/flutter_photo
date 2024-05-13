import 'package:flutter/material.dart';

class PhotoUserAvatar extends StatefulWidget {
  const PhotoUserAvatar({
    super.key,
    required this.userAvatarLink,
    required this.radius,
  });

  final String userAvatarLink;
  final double radius;

  @override
  State<PhotoUserAvatar> createState() => _PhotoUserAvatarState();
}

class _PhotoUserAvatarState extends State<PhotoUserAvatar> {
  @override
  Widget build(BuildContext context) {
    return
      widget.userAvatarLink.isNotEmpty
          ? CircleAvatar(
        radius: widget.radius,
        backgroundImage: NetworkImage(widget.userAvatarLink),
      )
          : CircleAvatar(
        radius: widget.radius,
        backgroundImage:
        const AssetImage('assets/images/default_profile_avatar.png'),
      );
  }
}

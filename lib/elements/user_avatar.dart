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
        child: ClipOval(
          child: Image.network(
            widget.userAvatarLink,
            fit: BoxFit.cover,
            width: widget.radius * 2,
            height: widget.radius * 2,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Center(
                child: Icon(Icons.error),
              );
            },
          ),
        ),
      )
          : CircleAvatar(
        radius: widget.radius,
        backgroundImage:
        const AssetImage('assets/images/default_profile_avatar.png'),
      );
  }
}

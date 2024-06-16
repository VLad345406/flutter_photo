import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class DisplayVideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double width;

  const DisplayVideoThumbnail({
    super.key,
    required this.videoUrl,
    required this.width,
  });

  @override
  State<DisplayVideoThumbnail> createState() => _DisplayVideoThumbnailState();
}

class _DisplayVideoThumbnailState extends State<DisplayVideoThumbnail> {
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      quality: 100,
    );

    setState(() {
      _thumbnailUrl = thumbnailPath;
      print(_thumbnailUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Center(
        child: _thumbnailUrl != null
            ? Image.file(
                File(_thumbnailUrl!),
                width: widget.width,
                height: widget.width,
                fit: BoxFit.cover,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

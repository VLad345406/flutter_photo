import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String fileName;
  final String fileLink;

  const VideoPlayerScreen({
    super.key,
    required this.fileName,
    required this.fileLink,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;
  bool _controlsVisible = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.fileLink);

    _initializeVideoPlayerFuture = _controller.initialize().catchError((error) {
      print('Error initializing video player: $error');
    }).then((_) {
      setState(() {});
    });

    if (!kIsWeb) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      _fadeAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      );

      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (!kIsWeb) {
      _animationController.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
      if (!kIsWeb) {
        if (_controlsVisible) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_controller.value.isInitialized) {
              return GestureDetector(
                onTap: kIsWeb ? () {} : _toggleControls,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    if (!kIsWeb)
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return _controlsVisible
                              ? Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Container(
                                    color: Colors.black54,
                                  ),
                                )
                              : SizedBox.shrink();
                        },
                      ),
                    if (kIsWeb && _controlsVisible)
                      Container(
                        color: Colors.transparent,
                      ),
                    if (!kIsWeb)
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: IgnorePointer(
                              ignoring: !_controlsVisible,
                              child: _buildControls(),
                            ),
                          );
                        },
                      )
                    else if (kIsWeb && _controlsVisible)
                      _buildControls(),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Failed to load video.'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: kIsWeb
                ? 20
                : Platform.isIOS
                    ? 50
                    : 20,
            left: 16,
            right: 16,
          ),
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/back_arrow.svg',
                    width: 12.21,
                    height: 11.35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  widget.fileName,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        !kIsWeb
            ? Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
              )
            : Container(),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            left: 16,
            right: 16,
          ),
          child: Row(
            children: [
              kIsWeb
                  ? IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    )
                  : Container(),
              Expanded(
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                ),
              ),
              !kIsWeb
                  ? IconButton(
                      icon: Icon(
                        _isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      onPressed: _toggleFullScreen,
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

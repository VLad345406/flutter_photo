import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String fileName;
  final String fileLink;

  const AudioPlayerScreen({
    super.key,
    required this.fileName,
    required this.fileLink,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    });
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(widget.fileLink));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            widget.fileName,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Slider(
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeColor: Colors.grey,
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _seekToSecond(value.toInt());
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: _playPause,
            iconSize: 50,
          ),
          Text(
            "${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}",
            style: GoogleFonts.roboto(
              fontSize: 15,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

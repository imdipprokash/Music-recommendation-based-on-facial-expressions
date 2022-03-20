import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {

  final String id;

  VideoScreen({required this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

   YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags:const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:Colors.blueAccent,),
      backgroundColor:const Color.fromARGB(255, 178, 185, 190),
      body: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        onReady: () {
          if (kDebugMode) {
            print('Player is ready.');
          }
        },
      ),
    );
  }
}
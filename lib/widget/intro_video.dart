import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroVideo extends StatefulWidget {
  @override
  _IntroVideoState createState() => _IntroVideoState();
}

class _IntroVideoState extends State<IntroVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('qassets/introVideo.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VideoPlayer(_controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

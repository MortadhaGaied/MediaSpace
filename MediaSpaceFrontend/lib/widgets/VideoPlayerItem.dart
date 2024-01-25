import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool showPauseIcon = false;
  Timer? pauseIconTimer;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });

    videoPlayerController.setLooping(true);
    videoPlayerController.play();
  }

  void togglePlayPause() {
    if (videoPlayerController.value.isInitialized) {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
      } else {
        videoPlayerController.play();
      }
      setState(() {
        showPauseIcon = true;
      });

      pauseIconTimer?.cancel();
      pauseIconTimer = Timer(Duration(milliseconds: 100), () {
        setState(() {
          showPauseIcon = false;
        });
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    pauseIconTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => togglePlayPause(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center( // This will center the video player within the Stack
            child: videoPlayerController.value.isInitialized
                ? AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            )
                : Container(
              color: Colors.black,

            ),
          ),
          if (showPauseIcon)
            Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 50.0,
            ),
        ],
      ),
    );
  }




}

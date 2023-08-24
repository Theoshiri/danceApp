// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dance_app/learn_screen/video_item.dart';
import 'dart:async';

class PlayVideoPage extends StatefulWidget {
  const PlayVideoPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String url;
  final String title;

  @override
  State<PlayVideoPage> createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _setVideoController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> _setVideoController() async {
    VideoPlayerController controller;
    print('Play video');
    controller = VideoPlayerController.network(widget.url);
    print('network:' + widget.url);

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/dance-logo.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _controller != null
          ? Center(
              child: Column(
                children: [
                  Container(
                    height: height * 0.40,
                    color: Color(0xFF232222),
                    child: VideoItems(
                      videoPlayerController: _controller!,
                      autoplay: false,
                      looping: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'There was an error playing the video',
                    style: TextStyle(fontSize: 50),
                    selectionColor: Colors.red,
                  ),
                ],
              ),
            ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../learn_screen/video_item.dart';
import 'result.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  VideoPlayerController? _controller1;
  XFile? _video1File;

  final ImagePicker _picker = ImagePicker();

  Future<void> _setVideoController(XFile file) async {
    if (file != null && mounted) {
      VideoPlayerController controller;
      print('play video ');
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
        print('network:' + file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
        print('file:' + file.path);
      }
      setState(() {
        _controller1 = controller;
      });
    }
  }

  void _onVideo1ButtonPressed(ImageSource source) async {
    _video1File = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));

    if (_video1File != null) {
      await _setVideoController(_video1File!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _controller1 != null
          ? Column(
              children: [
                Container(
                  height: height * 0.40,
                  color: Color(0xFF232222),
                  child: VideoItems(
                    videoPlayerController: _controller1!,
                    autoplay: false,
                    looping: false,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.pinkAccent),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ResultPage(
                                    title: 'Analyzed Dance',
                                    video1File: _video1File!,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Analyze Video',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller1 = null;
                                  _video1File = null;
                                });
                              },
                              icon: const Icon(Icons.delete)))
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset(
                    'assets/images/dance-logo.png',
                    height: 150,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Motion Mentor',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pinkAccent),
                      ),
                      onPressed: () {
                        _onVideo1ButtonPressed(ImageSource.gallery);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.upload_rounded,
                            size: 50.0,
                            semanticLabel: 'Upload a Video',
                            color: Colors.white,
                          ),
                          Text(
                            'Upload a Video',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // const Text(
                  //   'OR',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pinkAccent),
                      ),
                      onPressed: () {
                        _onVideo1ButtonPressed(ImageSource.camera);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.video_camera_front_sharp,
                            size: 50.0,
                            semanticLabel: 'Record a Video',
                            color: Colors.white,
                          ),
                          Text(
                            'Record a Video',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(_video1File != null ? _video1File!.path : ''),
                  const SizedBox(
                    height: 30,
                  ),
                ])),
    );
  }
}

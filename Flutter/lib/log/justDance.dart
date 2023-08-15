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
    await _setVideoController(_video1File!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller1 != null
          ? Column(
              children: [
                Container(
                  height: 500,
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ResultPage()));
                            },
                            child: const Text(
                              'Analyze Videos',
                              style: TextStyle(fontSize: 30),
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
                  const Text(
                    'Just Dance',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ButtonStyle(
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
                            'Upload Video',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('OR'),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ButtonStyle(
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

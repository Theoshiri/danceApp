// ignore_for_file: prefer_const_constructors

import 'package:dance_app/learn_screen/video_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultPage extends StatefulWidget {
  ResultPage({
    Key? key,
    required this.title,
    required this.video1File,
  }) : super(key: key);

  XFile video1File;
  final String title;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String analyzedVideoUrl = '';
  VideoPlayerController? _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    uploadFileToServer();
  }

  Future<void> _saveVideo(url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dates = [];
    dates = prefs.getStringList('date') ?? [];

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm a');
    String formattedDate = formatter.format(now);
    dates.add(formattedDate);
    prefs.setStringList('date', dates);
    prefs.setString(formattedDate, json.encode(url));
  }

  void uploadFileToServer() async {
    // This url is for the local server. Change later to the public url.
    var url = 'http://10.0.2.2:5000/'; // Local host

    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeeout=5, max=1000"
    };

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse('$url/analyze_dance'));
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        widget.video1File.path,
        contentType: MediaType('application', 'MOV'),
      ),
    );

    request.send().then((r) async {
      print(r.statusCode);

      if (r.statusCode == 200) {
        var result = json.decode(await r.stream.transform(utf8.decoder).join());
        _saveVideo(result);
        setState(() {
          analyzedVideoUrl = result;
          _setVideoController(analyzedVideoUrl);
          isLoading = false;
        });
      }
    });
  }

  Future<void> _setVideoController(url) async {
    VideoPlayerController controller;
    print('Play video');
    controller = VideoPlayerController.network(url);

    setState(() {
      _controller = controller;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        // toolbarHeight: 100,
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
      body: isLoading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            )
          : _controller != null
              ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: height * 0.4,
                          color: const Color(0xFF232222),
                          child: VideoItems(
                            videoPlayerController: _controller!,
                            autoplay: false,
                            looping: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                            maxLines: 3,
                          ),
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

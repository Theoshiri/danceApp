// ignore_for_file: prefer_const_constructors
import 'package:dance_app/learn_screen/play_video.dart';
import 'package:dance_app/firebase/db.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Map links = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  getVideos() async {
    getVideoFiles('dance_tutorial').then((value) => setState(() {
          print(value);
          if (value != null) links = value!;
        }));
    Future.delayed(const Duration(seconds: 5)).then((value) {
      setState(() {
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? links.isNotEmpty
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: links!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String title = links.keys.elementAt(index);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Card(
                          color: Colors.orangeAccent,
                          child: ListTile(
                            title: Text(
                              title.substring(0, title.length - 4),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.play_circle,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayVideoPage(
                                              url: links![title],
                                              title: title.substring(
                                                  0, title.length - 4),
                                            )));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ))
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No videos found'),
                    )
                  ],
                ))
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Loading Videos ...'),
                )
              ],
            )),
    );
  }
}

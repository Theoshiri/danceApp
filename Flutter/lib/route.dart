// ignore_for_file: prefer_const_constructors

import 'package:dance_app/home_screen.dart';
import 'package:dance_app/learn_screen/tip_screen.dart';
import 'package:dance_app/learn_screen/video_screen.dart';
import 'package:dance_app/log/justDance.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'dart:ui' as ui;

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget>? _widgetOptions;
  String title = 'Home';

  void initState() {
    _widgetOptions = [
      const HomePage(),
      const TipPage(),
      const VideoPage(),
      UploadPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(155, 241, 140, 1.0),
          ),
        ),
      ),
      drawer: MultiLevelDrawer(
        backgroundColor: Colors.white,
        rippleColor: Colors.white,
        subMenuBackgroundColor: Colors.grey.shade100,
        header: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset(
                //   'assets/images/dance-logo.png',
                //   fit: BoxFit.fitHeight,
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 60.0, left: 30.0, right: 30.0, bottom: 20.0),
                  child: Image.asset(
                    'assets/images/dance-logo.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(
                  'Dance App',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    // foreground: Paint()
                    //   ..shader = ui.Gradient.linear(
                    //     const Offset(0, 20),
                    //     const Offset(150, 20),
                    //     <Color>[
                    //       Color(0xFF88E763),
                    //       Color(0xFFE7A563),
                    //     ],
                    //   ),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        children: [
          MLMenuItem(
              trailing: const Icon(
                Icons.home,
                color: Colors.blue,
              ),
              content: const Text(
                "Home",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onClick: () {
                setState(() {
                  _selectedIndex = 0;
                  title = 'Home';
                  Navigator.pop(context);
                  print(_selectedIndex);
                });
              }),
          MLMenuItem(
            trailing: const Icon(
              Icons.help,
              color: Colors.orange,
            ),
            content: const Text(
              "Learn",
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            subMenuItems: [
              MLSubmenu(
                  onClick: () {
                    setState(() {
                      _selectedIndex = 1;
                      title = 'Tips';
                      Navigator.pop(context);
                    });
                  },
                  submenuContent: const Text('Useful Tips')),
              MLSubmenu(
                  onClick: () {
                    setState(() {
                      _selectedIndex = 2;
                      title = 'Videos';
                      Navigator.pop(context);
                    });
                  },
                  submenuContent: const Text('Useful Videos')),
            ],
            onClick: () {},
          ),
          MLMenuItem(
              trailing: const Icon(
                Icons.video_camera_front_rounded,
                color: Colors.pinkAccent,
              ),
              content: const Text(
                'Just Dance',
                style: TextStyle(color: Colors.pinkAccent),
              ),
              onClick: () {
                setState(() {
                  _selectedIndex = 3;
                  title = 'Just Dance';
                  Navigator.pop(context);
                  print(_selectedIndex);
                });
              }),
        ],
      ),
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
    );
  }
}

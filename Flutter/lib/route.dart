// ignore_for_file: prefer_const_constructors

import 'package:dance_app/history.dart';
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

  final Map<int, Color> appBarColors = {
    0: Colors.blue,
    1: Colors.orange,
    2: Colors.orange,
    3: Colors.pinkAccent,
    4: Colors.green,
  };

  void initState() {
    _widgetOptions = [
      const HomePage(),
      const TipPage(),
      const VideoPage(),
      UploadPage(),
      HistoryPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = appBarColors[_selectedIndex] ?? Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBarColor,
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
          MLMenuItem(
              trailing: const Icon(
                Icons.history,
                color: Colors.green,
              ),
              content: const Text(
                'History',
                style: TextStyle(color: Colors.green),
              ),
              onClick: () {
                setState(() {
                  _selectedIndex = 4;
                  title = 'History';
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

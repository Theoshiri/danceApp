import 'package:dance_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'dart:ui' as ui;

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

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
                Image.asset(
                  'assets/images/dance-logo.png',
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Dance App',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 20),
                        const Offset(150, 20),
                        <Color>[
                          Color(0xFF88E763),
                          Color(0xFFE7A563),
                        ],
                      ),
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
                  title = 'HOME';
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

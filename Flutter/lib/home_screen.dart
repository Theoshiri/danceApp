// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> info = [
    "WHAT ARE WE?| [APP NAME HERE] uses state-of-the-art pose-estimation technology to analyze very detail of an individual's ballroom dancing, including shoulder balance, hip angle, and distance from the camera.",
    "WHAT DO WE DO?| In addition, our advanced algorithms can track the speed of your movement as a person dances towards or away from the camera, providing real-time feedback on their performance.",
  ];

  String extractTitle(String text) {
    final parts = text.split('|');
    if (parts.isNotEmpty) {
      return parts[0];
    }
    return '';
  }

  String extractSubtitle(String text) {
    final parts = text.split('|');
    if (parts.length > 1) {
      return parts[1];
    }
    return parts[0];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: info.length,
                    itemBuilder: (context, index) {
                      final infoTitle = extractTitle(info[index]);
                      final infoSubtitle = extractSubtitle(info[index]);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Card(
                          color: Colors.blue[200],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(
                                infoTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  SizedBox(height: 8.0),
                                  Text(
                                    infoSubtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

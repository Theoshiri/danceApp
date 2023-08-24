import 'package:dance_app/learn_screen/play_video.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map _history = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List dates = [];
    print(prefs.containsKey('date'));
    if (prefs.containsKey('date')) {
      dates = prefs.getStringList('date')!;
      for (var date in dates) {
        _history[date] = json.decode(prefs.getString(date)!);
      }

      print(_history.keys);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _history.length,
        itemBuilder: (BuildContext context, int index) {
          print('history');
          String date = _history.keys.elementAt(index);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Card(
              color: Colors.green,
              child: ListTile(
                title: Text(
                  date,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.play_circle_filled_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Show Video',
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PlayVideoPage(
                                url: _history[date], title: date)));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

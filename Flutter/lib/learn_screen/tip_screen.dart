import 'package:flutter/material.dart';

class TipPage extends StatefulWidget {
  const TipPage({super.key});

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  List<String> tips = [
    "Find a good instructor: Working with a skilled and experienced ballroom dance instructor is crucial. They can teach you proper technique, help you improve your dance skills, and provide valuable feedback and guidance.",
    "Practice makes perfect: The more you practice, the smoother your moves will become.",
    "Pay attention to footwork: Footwork is a fundamental aspect of ballroom dance. Work on maintaining proper foot placement, weight distribution, and alignment. Practice the different footwork patterns and steps of each dance style to build muscle memory and precision."
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Text(
              "Here are some useful tips for ballroom dance:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange[900],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.orangeAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.orange[800],
                          ),
                          children: [
                            TextSpan(
                              text: "Tip ${index + 1}: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: tips[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MCQPage extends StatefulWidget {
  const MCQPage({super.key});

  @override
  State<MCQPage> createState() => _MCQPageState();
}

class _MCQPageState extends State<MCQPage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Scaffold(
          body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("1 img"),
              Text("2 userName"),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Text("Course Section"),
            ),
          ),
          SizedBox(
            child: Text("here"),
          )
        ],
      )),
    );
  }
}

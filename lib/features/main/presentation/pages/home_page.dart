import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/add_new_question.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/topics/microprocessor.dart';

class MCQMainPage extends StatefulWidget {
  const MCQMainPage({super.key});

  @override
  State<MCQMainPage> createState() => _MCQMainPageState();
}

class _MCQMainPageState extends State<MCQMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ  App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewQuestion.route());
            },
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                Microprocessor.route(),
              );
            },
            child: const Text("Microprocessor"),
          ),
        ],
      ),
    );
  }
}

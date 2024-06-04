import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/add_new_question.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
      body: Center(
        child: Text("Login"),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AddNewQuestion extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddNewQuestion());
  
  const AddNewQuestion({super.key});

  @override
  State<AddNewQuestion> createState() => _AddNewQuestionState();
}

class _AddNewQuestionState extends State<AddNewQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon:const Icon(
              Icons.done_rounded,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/add_new_question.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/topics/DL/DL.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/topics/DSA/dsa.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/topics/TOC/toc.dart';
import 'package:neclicensepreperation/features/main/widgets/gradient_button.dart';
import 'package:neclicensepreperation/features/main/widgets/transition_logo.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const LogoTransition(),
            GradientBtn(
              buttonText: "Digital Logic And Microprocessor",
              onPressed: () {
                Navigator.push(
                  context,
                  DL.route(),
                );
              },
            ),
            const SizedBox(height: 20),
            GradientBtn(
              buttonText: "Theory Of Computation",
              onPressed: () {
                Navigator.push(
                  context,
                  TOC.route(),
                );
              },
            ),
            const SizedBox(height: 20),
            GradientBtn(
              buttonText: "DataStructure and Algorithms",
              onPressed: () {
                Navigator.push(
                  context,
                  Dsa.route(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

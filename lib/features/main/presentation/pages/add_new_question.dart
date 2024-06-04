import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/core/app_pallete.dart';

class AddNewQuestion extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewQuestion());

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
            icon: const Icon(
              Icons.done_rounded,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DottedBorder(
              color: AppPallete.borderColor,
              radius: const Radius.circular(10),
              borderType: BorderType.RRect,
              strokeCap: StrokeCap.round,
              dashPattern: const [10, 4],
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.question_answer_outlined),
                      Text("Please Enter Questions ?")
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  "Technology",
                  "Technology",
                  "Technology",
                  "Technology",
                  "Technology",
                ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Chip(
                          side: const BorderSide(color: AppPallete.borderColor),
                          label: Text(e),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

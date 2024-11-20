import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/AI_Chatbot/AIBOT.dart';
import 'package:neclicensepreperation/features/questions/widgets/optionbutton.dart';
import 'package:neclicensepreperation/features/questions/widgets/video_player.dart';

class QuestionItem extends StatelessWidget {
  final Question question;
  final String? userAnswer;
  final Function(String) onOptionSelected;

  const QuestionItem({
    Key? key,
    required this.question,
    required this.userAnswer,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              question.question.toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 20),
        OptionButton(
          text: question.option1,
          isSelected: userAnswer == question.option1,
          onPressed: () => onOptionSelected(question.option1),
          isCorrect: userAnswer == question.answer,
          isDisabled: userAnswer != null,
        ),
        const SizedBox(height: 10),
        OptionButton(
          text: question.option2,
          isSelected: userAnswer == question.option2,
          onPressed: () => onOptionSelected(question.option2),
          isCorrect: userAnswer == question.answer,
          isDisabled: userAnswer != null,
        ),
        const SizedBox(height: 10),
        OptionButton(
          text: question.option3,
          isSelected: userAnswer == question.option3,
          onPressed: () => onOptionSelected(question.option3),
          isCorrect: userAnswer == question.answer,
          isDisabled: userAnswer != null,
        ),
        const SizedBox(height: 10),
        OptionButton(
          text: question.option4,
          isSelected: userAnswer == question.option4,
          onPressed: () => onOptionSelected(question.option4),
          isCorrect: userAnswer == question.answer,
          isDisabled: userAnswer != null,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AIBOT(
                      question: question.question,
                      op1: question.option1,
                      op2: question.option2,
                      op3: question.option3,
                      op4: question.option4,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 65, 120),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: const Text(
                  "Have Doubts",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoGuidePage(query: question.question),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 246, 0, 74),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: const Text(
                  "Video Guide",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

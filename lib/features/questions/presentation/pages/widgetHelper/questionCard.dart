import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/AI_Chatbot/AIBOT.dart';
import 'package:neclicensepreperation/features/questions/widgets/option_button.dart';

import '../../../domain/entities/question.dart';

class QuestionCard extends StatelessWidget {
  final int questionIndex;
  final Question question;
  final String? userAnswer;
  final Function(String) onOptionSelected;

  const QuestionCard(
      {Key? key,
      required this.questionIndex,
      required this.question,
      required this.userAnswer,
      required this.onOptionSelected})
      : super(key: key);

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
              '${questionIndex + 1}  ${question.question.toUpperCase()}',
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AIBOT(question.question)),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: const Text(
              "Have Doubts",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

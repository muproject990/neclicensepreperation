import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/widgets/questionitems.dart';

class QuestionList extends StatelessWidget {
  final List<Question> questions;
  final List<String?> userAnswers;
  final Function(int, String) onOptionSelected;

  const QuestionList({
    Key? key,
    required this.questions,
    required this.userAnswers,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return QuestionItem(
          question: question,
          userAnswer: userAnswers[index],
          onOptionSelected: (selectedOption) {
            onOptionSelected(index, selectedOption);
          },
        );
      },
    );
  }
}

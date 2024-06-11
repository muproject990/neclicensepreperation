import 'package:flutter/material.dart';

class QuestionWithOptions extends StatefulWidget {
  const QuestionWithOptions({super.key});

  @override
  _QuestionWithOptionsState createState() => _QuestionWithOptionsState();
}

class _QuestionWithOptionsState extends State<QuestionWithOptions> {
  // Define the question and options
  String question = 'What is the capital of France?';
  List<String> options = [
    'Paris',
    'Berlin',
    'Madrid',
    'Rome',
  ];

  // Keep track of the selected option
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...options.asMap().entries.map(
          (entry) {
            int index = entry.key;
            String option = entry.value;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = index;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedOption == index ? Colors.green : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedOption == index
                            ? Colors.green
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedOption == index
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      child: selectedOption == index
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}

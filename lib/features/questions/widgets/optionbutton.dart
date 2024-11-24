import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isDisabled; // To disable the button after selection
  final VoidCallback onPressed;

  const OptionButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isDisabled, // Disable when an answer is selected
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the button color
    Color buttonColor = isSelected
        ? (isCorrect
            ? Colors.green
            : Colors.red) // Green for correct, red for incorrect
        : Colors.grey; // Default color when not selected

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
          ),
          onPressed:
              isDisabled ? null : onPressed, // Disable if answer is selected
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 14, 12, 12),
              fontSize: 16,
            ),
          ),
        ),
        if (isSelected) ...[
          const SizedBox(height: 5),
          Text(
            isCorrect ? "Correct Answer!" : "Incorrect Answer",
            style: TextStyle(
              color: isCorrect ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

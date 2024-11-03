import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration:
            const Duration(seconds: 1), // Optional: Adjust duration as needed
        behavior: SnackBarBehavior.floating, // Optional: Change behavior
      ),
    );
}

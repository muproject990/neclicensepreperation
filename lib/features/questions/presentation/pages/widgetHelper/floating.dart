import 'package:flutter/material.dart';

class FloatingSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const FloatingSubmitButton({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onSubmit,
      label: const Text("Submit"),
      icon: const Icon(Icons.check),
      backgroundColor: Colors.green,
    );
  }
}

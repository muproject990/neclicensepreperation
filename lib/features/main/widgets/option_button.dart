// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:neclicensepreperation/core/common/cubits/main_mcq/correctAns_cubit.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';

class MqcQuestionAnswer extends StatefulWidget {
  final String text;
  // final CorrectansCubit correctansCubit;
  final bool isCorrect;
  // final VoidCallback onCorrectAnswer;

  const MqcQuestionAnswer({
    Key? key,
    required this.text,
    // required this.correctansCubit,
    required this.isCorrect,
  }) : super(key: key);

  @override
  State<MqcQuestionAnswer> createState() => _MqcQuestionAnswerState();
}

class _MqcQuestionAnswerState extends State<MqcQuestionAnswer> {
  bool _isSelected = false;
  bool _isButtonDisabled = false;
  @override
  Widget build(BuildContext context) {
    final correctansCubit = BlocProvider.of<CorrectansCubit>(context);

    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: ElevatedButton(
        onPressed: _isButtonDisabled
            ? null
            : () {
                // Check if the button is disabled
                setState(() {
                  _isSelected = true;
                  _isButtonDisabled =
                      true; // Disable the button after it's clicked
                });

                if (widget.isCorrect) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Congratulations'),
                      backgroundColor: Colors.purple,
                    ),
                  );
                  correctansCubit.increment();
                } else {
                  correctansCubit.decrement();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect answer. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: _isSelected
              ? widget.isCorrect
                  ? Colors.green
                  : Colors.red
              : Colors.yellow[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(widget.text),
      ),
    );
  }
}

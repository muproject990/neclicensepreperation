import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/widgets/loader.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:neclicensepreperation/features/main/presentation/bloc/question_bloc.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/add_new_question.dart';

class Microprocessor extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Microprocessor(),
      );
  const Microprocessor({super.key});

  @override
  State<Microprocessor> createState() => _MicroprocessorState();
}

class _MicroprocessorState extends State<Microprocessor> {
  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<QuestionBloc, QuestionState>(
          listener: (context, state) {
            if (state is QuestionFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is QuestionLoading) {
              return const Loader();
            }

            if (state is QuestionDisplaySuccess) {
              return Center(
                child: ListView.builder(
                    itemCount: state.questions.length,
                    itemBuilder: (context, index) {
                      final question = state.questions[index];
                      return Text(question.question.toString());
                    }),
              );
            }
            return const SizedBox();
          },
        ));
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/cubits/main_mcq/correctAns_cubit.dart';
import 'package:neclicensepreperation/core/common/widgets/loader.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:neclicensepreperation/features/questions/presentation/bloc/question_bloc.dart';
import 'package:neclicensepreperation/features/questions/widgets/floating_btn.dart';
import 'package:neclicensepreperation/features/questions/widgets/option_button.dart';
import 'package:path_provider/path_provider.dart';

class DL extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const DL(),
      );
  const DL({super.key});

  @override
  State<DL> createState() => _DLState();
}

class _DLState extends State<DL> {
  List<String?> userAnswers = [];

  // save answer to filesystem
  Future<void> saveAnswersToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/user_answers.txt');

    StringBuffer content = StringBuffer();
    for (int i = 0; i < userAnswers.length; i++) {
      content.writeln('Question ${i + 1}: ${userAnswers[i]}');
    }

    await file.writeAsString(content.toString());
    showSnackBar(context, "Answers saved to file successfully!");
  }

  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  @override
  Widget build(BuildContext context) {
    final correctansCubit = BlocProvider.of<CorrectansCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CorrectansCubit, int>(
            bloc: correctansCubit,
            builder: (context, counter) {
              return Text(' Answered $counter out of 19');
            }),
      ),
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
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50, left: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey[600],
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              '${index + 1}  ${question.question.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MqcQuestionAnswer(
                          text: question.option1,
                          isCorrect: question.option1 == question.answer,
                          // correctansCubit: correctansCubit,
                        ),
                        const SizedBox(height: 10),
                        MqcQuestionAnswer(
                          text: question.option2,
                          isCorrect: question.option2 == question.answer,
                          // correctansCubit: correctansCubit,
                        ),
                        const SizedBox(height: 10),
                        MqcQuestionAnswer(
                          text: question.option3,
                          isCorrect: question.option3 == question.answer,
                          // correctansCubit: correctansCubit,
                        ),
                        const SizedBox(height: 10),
                        MqcQuestionAnswer(
                          text: question.option4,
                          isCorrect: question.option4 == question.answer,
                          // correctansCubit: correctansCubit,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16), // Increased margin for better spacing
        decoration: BoxDecoration(
          color: Colors.blueAccent, // Background color for the container
          borderRadius: BorderRadius.circular(30), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 10, // Blur radius for the shadow
              offset: Offset(0, 4), // Offset for the shadow
            ),
          ],
        ),
        child: FloatingBtn(
          buttonText: 'Done',
          onPressed: () {
            saveAnswersToFile(); // Save answers to a text file
          },
        ),
      ),
      // floatingActionButton: FloatingBtn(
      //   buttonText: 'Learn',
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       LearnDL.route(),
      //     );
      //   },
      // ),
    );
  }
}

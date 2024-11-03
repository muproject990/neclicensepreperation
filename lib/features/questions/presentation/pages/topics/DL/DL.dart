import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/cubits/main_mcq/correctAns_cubit.dart';
import 'package:neclicensepreperation/core/common/widgets/loader.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:neclicensepreperation/features/questions/presentation/bloc/question_bloc.dart';
import 'package:neclicensepreperation/features/questions/widgets/floating_btn.dart';
import 'package:neclicensepreperation/features/questions/widgets/optionbutton.dart';
import 'package:path_provider/path_provider.dart';

class DL extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const DL());
  const DL({super.key});

  @override
  State<DL> createState() => _DLState();
}

class _DLState extends State<DL> {
  List<String?> userAnswers = [];
  List<String> correctAnswers = []; // List to hold correct answers

  Future<void> showStatistics() async {
    final directory = await getApplicationDocumentsDirectory();
    final statsFile = File('${directory.path}/statistics.txt');

    if (await statsFile.exists()) {
      String fileContent = await statsFile.readAsString();

      // Display the content in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Statistics"),
            content: SingleChildScrollView(
              child: Text(fileContent.isNotEmpty
                  ? fileContent
                  : "No statistics found."),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showSnackBar(context, "No statistics file found.");
    }
  }

// appendResultsToStatisticsFile

  Future<void> appendResultsToStatisticsFile(
      int totalQuestions, int totalCorrectAnswers) async {
    final directory = await getApplicationDocumentsDirectory();
    final statsFile = File('${directory.path}/statistics.txt');

    StringBuffer content = StringBuffer();

    // Calculate percentage correct
    double percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;

    // Append current result
    content.writeln('Total Questions: $totalQuestions');
    content.writeln('Total Correct Answers: $totalCorrectAnswers');
    content.writeln(
        'Percentage Correct: ${percentageCorrect.toStringAsFixed(2)}%');
    content.writeln('---'); // Separator for each entry

    // Append to the file
    await statsFile.writeAsString(content.toString(), mode: FileMode.append);
    showSnackBar(context, "Statistics updated successfully!");
  }


  

  // Function to save user answers to a file
  Future<void> saveResultsToFile(
      int totalQuestions, int totalCorrectAnswers) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/results.txt');

    StringBuffer content = StringBuffer();

    // Save total number of questions and percentage of correct answers
    content.writeln('Total Questions: $totalQuestions');
    content.writeln('Total Correct Answers: $totalCorrectAnswers');

    double percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;
    content.writeln(
        'Percentage Correct: ${percentageCorrect.toStringAsFixed(2)}%');

    await file.writeAsString(content.toString());
    showSnackBar(context, "Results saved to file successfully!");
  }

  Future<void> showResults() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/results.txt');

    if (await file.exists()) {
      String fileContent = await file.readAsString();

      // Display the content in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Results"),
            content: SingleChildScrollView(
              child: Text(fileContent),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showSnackBar(context, "No results found.");
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CorrectAnsCubit, Map<String, int>>(
          builder: (context, state) {
            return Text(' Correct: ${state['correct']}');
          },
        ),
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
            if (userAnswers.isEmpty) {
              userAnswers = List<String?>.filled(state.questions.length, null);
              correctAnswers = state.questions.map((q) => q.answer).toList();
            }

            return ListView.builder(
              itemCount: state.questions.length,
              itemBuilder: (context, index) {
                final question = state.questions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${index + 1}  ${question.question.toUpperCase()}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Use the updated OptionButton

                    OptionButton(
                      text: question.option1,
                      isSelected: userAnswers[index] == question.option1,
                      onPressed: () =>
                          _handleOptionSelection(index, question.option1),
                    ),
                    const SizedBox(height: 10),
                    OptionButton(
                      text: question.option2,
                      isSelected: userAnswers[index] == question.option2,
                      onPressed: () =>
                          _handleOptionSelection(index, question.option2),
                    ),
                    const SizedBox(height: 10),
                    OptionButton(
                      text: question.option3,
                      isSelected: userAnswers[index] == question.option3,
                      onPressed: () =>
                          _handleOptionSelection(index, question.option3),
                    ),
                    const SizedBox(height: 10),
                    OptionButton(
                      text: question.option4,
                      isSelected: userAnswers[index] == question.option4,
                      onPressed: () =>
                          _handleOptionSelection(index, question.option4),
                    ),
                    const SizedBox(height: 10),
                    if (userAnswers[index] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Correct Answer: ${correctAnswers[index].toUpperCase()}',
                          style: TextStyle(
                            color: userAnswers[index] == correctAnswers[index]
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingBtn(
          buttonText: 'Done',
          onPressed: () {
            if (userAnswers.any((answer) => answer == null)) {
              showSnackBar(
                  context, "Please answer all questions before submitting.");
            } else {
              // Calculate total correct answers
              int totalCorrectAnswers =
                  userAnswers.asMap().entries.where((entry) {
                int index = entry.key;
                String? answer = entry.value;
                return answer == correctAnswers[index];
              }).length;

              // Save results to a file
              saveResultsToFile(userAnswers.length, totalCorrectAnswers);

              // Append results to the statistics file
              appendResultsToStatisticsFile(
                  userAnswers.length, totalCorrectAnswers);

              // Show results dialog
              showResults();
              // showStatistics();
            }
          },
        ),
      ),
    );
  }

  void _handleOptionSelection(int index, String selectedOption) {
    setState(() {
      // Check if the answer for this question is already set
      if (userAnswers[index] != null) {
        // If already answered, do nothing and return
        return;
      }

      // Update the user's answer for this question
      userAnswers[index] = selectedOption;

      // Update the answered count
      context.read<CorrectAnsCubit>().incrementAnswered();

      // Check if the selected option is correct or not
      if (selectedOption == correctAnswers[index]) {
        context.read<CorrectAnsCubit>().incrementCorrect();
      } else {
        // If the previous answer was correct, decrement the count
        if (userAnswers[index] == correctAnswers[index]) {
          context.read<CorrectAnsCubit>().decrementCorrect();
        }
      }
    });
  }
}

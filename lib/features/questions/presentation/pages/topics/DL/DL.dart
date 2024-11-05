import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/cubits/main_mcq/correctAns_cubit.dart';
import 'package:neclicensepreperation/core/common/widgets/loader.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/presentation/bloc/question_bloc.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/home_page.dart';
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
  List<String> correctAnswers = [];
  List<Question> selectedQuestions = [];

  Timer? _timer;
  int _remainingTime = 0;
  ValueNotifier<String> _timerDisplay = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  List<Question> selectRandomQuestions(
      List<Question> allQuestions, int numberOfQuestions) {
    if (allQuestions.length <= numberOfQuestions) {
      // If there are fewer than or equal to `numberOfQuestions`, return all questions
      return List<Question>.from(allQuestions);
    }

    // Copy the list so that the original list is not modified
    List<Question> questionsCopy = List<Question>.from(allQuestions);

    // Shuffle the list to get a random order
    questionsCopy.shuffle(Random());

    // Take the first `numberOfQuestions` items
    return questionsCopy.take(numberOfQuestions).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Assuming BlocConsumer builds the widget after questions are loaded
    if (context.read<QuestionBloc>().state is QuestionDisplaySuccess) {
      final questions =
          (context.read<QuestionBloc>().state as QuestionDisplaySuccess)
              .questions;

      // Shuffle and select only 50 questions
      selectedQuestions = selectRandomQuestions(questions, 50);

      userAnswers = List<String?>.filled(selectedQuestions.length, null);
      correctAnswers = selectedQuestions.map((q) => q.answer).toList();

      _startTimer(selectedQuestions.length);
    }
  }

  void _startTimer(int totalQuestions) {
    _remainingTime =
        totalQuestions * 60; // Set duration based on total questions
    _updateTimerDisplay();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        timer.cancel();
        if (userAnswers.isNotEmpty) {
          showSnackBar(
              context, "Time is up! Your answers have not been submitted.");
        }
        userAnswers.clear();

        Navigator.push(context, MCQMainPage.route());
      } else {
        _remainingTime--;
        _updateTimerDisplay();
      }
    });
  }

  void _updateTimerDisplay() {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    _timerDisplay.value =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> showStatistics() async {
    final directory = await getApplicationDocumentsDirectory();
    final statsFile = File('${directory.path}/statistics.txt');

    if (await statsFile.exists()) {
      String fileContent = await statsFile.readAsString();

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
                child: const Text("OK"),
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

  Future<void> appendResultsToStatisticsFile(
      int totalQuestions, int totalCorrectAnswers) async {
    final directory = await getApplicationDocumentsDirectory();
    final statsFile = File('${directory.path}/statistics.txt');

    StringBuffer content = StringBuffer();
    double percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;

    content.writeln('Total Questions: $totalQuestions');
    content.writeln('Total Correct Answers: $totalCorrectAnswers');
    content.writeln(
        'Percentage Correct: ${percentageCorrect.toStringAsFixed(2)}%');
    content.writeln('---');

    await statsFile.writeAsString(content.toString(), mode: FileMode.append);
    showSnackBar(context, "Statistics updated successfully!");
  }



  Future<void> saveResultsToFile(
      int totalQuestions, int totalCorrectAnswers) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/results.txt');

    StringBuffer content = StringBuffer();
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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Results"),
            content: SingleChildScrollView(
              child: Text(fileContent),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
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

  void _submitResults() {
    _timer?.cancel();

    // Ensure the lengths match before proceeding
    if (userAnswers.length == correctAnswers.length) {
      int totalCorrectAnswers = userAnswers.asMap().entries.where((entry) {
        int index = entry.key;
        String? answer = entry.value;
        return answer == correctAnswers[index];
      }).length;

      saveResultsToFile(userAnswers.length, totalCorrectAnswers);
      appendResultsToStatisticsFile(userAnswers.length, totalCorrectAnswers);
      showResults();
    } else {
      showSnackBar(
          context, "Error: Answers and correct answers length mismatch.");
    }
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
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: _timerDisplay,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is QuestionFailure) {
            showSnackBar(context, state.error);
          } else if (state is QuestionDisplaySuccess) {
            // Only initialize answers if questions are loaded
            if (userAnswers.isEmpty) {
              userAnswers = List<String?>.filled(state.questions.length, null);
              correctAnswers = state.questions.map((q) => q.answer).toList();
              _startTimer(state.questions.length);
            }
          }
        },
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Loader();
          }

          if (state is QuestionDisplaySuccess) {
            if (state.questions.isEmpty) {
              return const Center(child: Text("No questions available."));
            }
            return ListView.builder(
              itemCount:
                  selectedQuestions.length, // Now displays only 50 questions
              itemBuilder: (context, index) {
                final question = selectedQuestions[index];
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
              _submitResults();
            }
          },
        ),
      ),
    );
  }

  void _handleOptionSelection(int index, String selectedOption) {
    setState(() {
      if (userAnswers[index] != null) return; // Prevent re-selection
      userAnswers[index] = selectedOption;

      context.read<CorrectAnsCubit>().incrementAnswered();

      if (selectedOption == correctAnswers[index]) {
        context.read<CorrectAnsCubit>().incrementCorrect();
      }
    });
  }
}

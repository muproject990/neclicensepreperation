import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
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
  int desiredQuestions = 50;
  List<String?> userAnswers = [];
  List<String> correctAnswers = [];
  List<Question> selectedQuestions = [];
  late String user;

  Timer? _timer;
  int _remainingTime = 0;
  ValueNotifier<String> _timerDisplay = ValueNotifier<String>("");

  // Performance Tracking
  int totalQuestions = 0;
  int correctAnswersCount = 0;
  List<int> responseTimes = [];
  DateTime? questionStartTime;

  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  List<Question> selectQuestionsByDifficulty(
      List<Question> allQuestions, int numberOfQuestions, double userAccuracy) {
    double easyThreshold = 70.0;
    double hardThreshold = 90.0;

    List<Question> selectedQuestions;
    if (userAccuracy < easyThreshold) {
      selectedQuestions =
          allQuestions.where((q) => q.difficulty == 'easy').toList();
    } else if (userAccuracy < hardThreshold) {
      selectedQuestions =
          allQuestions.where((q) => q.difficulty != 'hard').toList();
    } else {
      selectedQuestions =
          allQuestions.where((q) => q.difficulty == 'hard').toList();
    }

    selectedQuestions.shuffle(Random());
    return selectedQuestions.take(numberOfQuestions).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.read<QuestionBloc>().state is QuestionDisplaySuccess) {
      final questions =
          (context.read<QuestionBloc>().state as QuestionDisplaySuccess)
              .questions;

      double userAccuracy = correctAnswersCount /
          (totalQuestions == 0 ? 1 : totalQuestions) *
          100;
      selectedQuestions = selectQuestionsByDifficulty(
          questions, desiredQuestions, userAccuracy);

      userAnswers = List<String?>.filled(selectedQuestions.length, null);
      correctAnswers = selectedQuestions.map((q) => q.answer).toList();
      _startTimer(selectedQuestions.length);
    }
  }

  void _startTimer(int totalQuestions) {
    _remainingTime = totalQuestions * 20;
    _updateTimerDisplay();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        timer.cancel();
        if (userAnswers.isNotEmpty && mounted) {
          showSnackBar(
              context, "Time is up! Your answers have not been submitted.");
          Navigator.push(context, MCQMainPage.route());
        }
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
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      final statsFile = File('${directory.path}/statistics_$userId.txt');

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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        showSnackBar(context, "No statistics file found for this user.");
      }
    } else {
      showSnackBar(context, "Error: User not authenticated.");
    }
  }

  Future<void> appendResultsToStatisticsFile(
      int totalQuestions, int totalCorrectAnswers) async {
    final directory = await getApplicationDocumentsDirectory();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      final statsFile = File('${directory.path}/statistics_$userId.txt');

      double percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;
      await statsFile.writeAsString(
        'Total Questions: $totalQuestions\nTotal Correct Answers: $totalCorrectAnswers\nPercentage Correct: ${percentageCorrect.toStringAsFixed(2)}%\n---\n',
        mode: FileMode.append,
      );
      showSnackBar(context, "Statistics updated successfully!");
    } else {
      showSnackBar(context, "Error: User not authenticated.");
    }
  }

  void _submitResults() {
    _timer?.cancel();

    if (userAnswers.length == correctAnswers.length) {
      int totalCorrectAnswers = userAnswers.asMap().entries.where((entry) {
        int index = entry.key;
        String? answer = entry.value;
        return answer == correctAnswers[index];
      }).length;

      appendResultsToStatisticsFile(userAnswers.length, totalCorrectAnswers);
      showStatistics();
    } else {
      showSnackBar(
          context, "Error: Answers and correct answers length mismatch.");
    }
  }

  void _handleOptionSelection(int index, String selectedOption) {
    setState(() {
      if (userAnswers[index] != null) return;
      userAnswers[index] = selectedOption;

      if (selectedOption == correctAnswers[index]) {
        correctAnswersCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose correct Ans..'),
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: _timerDisplay,
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is QuestionFailure) {
            showSnackBar(context, state.error);
          } else if (state is QuestionDisplaySuccess) {
            final questions = state.questions;
            double userAccuracy = correctAnswersCount /
                (totalQuestions == 0 ? 1 : totalQuestions) *
                100;

            // Set selected questions based on difficulty and accuracy
            selectedQuestions = selectQuestionsByDifficulty(
                questions, desiredQuestions, userAccuracy);

            // Initialize user answers and correct answers lists based on selected questions
            userAnswers = List<String?>.filled(selectedQuestions.length, null);
            correctAnswers = selectedQuestions.map((q) => q.answer).toList();

            // Start the timer only after questions are selected
            _startTimer(selectedQuestions.length);
          }
        },
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Loader();
          } else if (state is QuestionDisplaySuccess) {
            if (selectedQuestions.isEmpty) {
              return const Center(child: Text("No questions available."));
            }
            return ListView.builder(
              itemCount: selectedQuestions.length,
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
                    const SizedBox(height: 50),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text("Failed to load questions."));
          }
        },
      ),
      floatingActionButton: Container(
        child: FloatingBtn(
          icon: Icons.done,
          onPressed: _submitResults,
          buttonText: 'Submit',
        ),
      ),
    );
  }
}

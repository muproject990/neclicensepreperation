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
  double userAccuracy = 0.0; // Dynamic user accuracy
  List<int> responseTimes = [];
  DateTime? questionStartTime;

  int consecutiveCorrectAnswers = 0;
  int consecutiveIncorrectAnswers = 0;
  int difficultyThreshold = 4; // Increase difficulty after 4 correct answers
  int decreaseDifficultyThreshold =
      39; // Decrease difficulty after 3 incorrect answers

  @override
  void initState() {
    super.initState();
    // _loadUserStatistics();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  // Load user's statistics and analyze recent performance
  Future<void> _loadUserStatistics() async {
    final directory = await getApplicationDocumentsDirectory();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      final statsFile = File('${directory.path}/statistics_$userId.txt');

      if (await statsFile.exists()) {
        final stats = await statsFile.readAsString();
        // Extract previous stats; this is just a sample way to calculate.
        final totalCorrect =
            RegExp(r'Total Correct Answers: (\d+)').firstMatch(stats)?.group(1);
        final totalQuestions =
            RegExp(r'Total Questions: (\d+)').firstMatch(stats)?.group(1);

        if (totalCorrect != null && totalQuestions != null) {
          final accuracy =
              int.parse(totalCorrect) / int.parse(totalQuestions) * 100;
          setState(() {
            userAccuracy = accuracy;
          });
        }
      }
    }
  }

  void _updateDifficultyBasedOnPerformance() {
    if (consecutiveCorrectAnswers >= difficultyThreshold) {
      setState(() {
        consecutiveCorrectAnswers = 0; // Reset after reaching threshold
        userAccuracy = 90.0; // Adjust this based on real user performance
      });
      _loadNewQuestions();
    }
  }

  void _loadNewQuestions() {
    final questions =
        (context.read<QuestionBloc>().state as QuestionDisplaySuccess)
            .questions;
    setState(() {
      selectedQuestions =
          selectQuestionsByDifficulty(questions, desiredQuestions);
      userAnswers = List<String?>.filled(selectedQuestions.length, null);
      correctAnswers = selectedQuestions.map((q) => q.answer).toList();
      _startTimer(selectedQuestions.length); // Restart timer for new questions
    });
  }

  List<Question> selectQuestionsByDifficulty(
      List<Question> allQuestions, int numberOfQuestions) {
    double easyThreshold = 70.0;
    double mediumThreshold = 80.0;
    double hardThreshold = 90.0;

    List<Question> filteredQuestions;

    // Adjust questions based on user accuracy
    if (userAccuracy < easyThreshold) {
      // For lower accuracy, select mostly easy questions
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'easy').toList();
      print("Selected Easy Questions - User Accuracy: $userAccuracy");
    } else if (userAccuracy < mediumThreshold) {
      // For mid-range accuracy, select medium questions
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'medium').toList();
      print("Selected Medium Questions - User Accuracy: $userAccuracy");
    } else if (userAccuracy < hardThreshold) {
      // For high accuracy but below the hardest level, include hard questions
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'hard').toList();
      print("Selected Hard Questions - User Accuracy: $userAccuracy");
    } else {
      // Highest accuracy users get very hard questions
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'very_hard').toList();
    }

    // Shuffle and take only the desired number of questions
    filteredQuestions.shuffle(Random());
    return filteredQuestions.take(numberOfQuestions).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.read<QuestionBloc>().state is QuestionDisplaySuccess) {
      final questions =
          (context.read<QuestionBloc>().state as QuestionDisplaySuccess)
              .questions;
      selectedQuestions =
          selectQuestionsByDifficulty(questions, desiredQuestions);

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
        if (userAnswers.isNotEmpty) {
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

  // Handle option selection, updating userAnswers list
  void _handleOptionSelection(int index, String selectedOption) {
    setState(() {
      userAnswers[index] = selectedOption;

      if (selectedOption == correctAnswers[index]) {
        consecutiveCorrectAnswers++;
        consecutiveIncorrectAnswers = 0; // Reset incorrect counter
        // Increase difficulty if threshold reached
        if (consecutiveCorrectAnswers >= difficultyThreshold) {
          consecutiveCorrectAnswers = 0;
          userAccuracy += 5; // Increase accuracy to select harder questions
          _loadNewQuestions();
        }
      } else {
        consecutiveIncorrectAnswers++;
        consecutiveCorrectAnswers = 0; // Reset correct counter
        // Decrease difficulty if threshold reached
        if (consecutiveIncorrectAnswers >= decreaseDifficultyThreshold) {
          consecutiveIncorrectAnswers = 0;
          userAccuracy -= 5; // Decrease accuracy to select easier questions
          _loadNewQuestions();
        }
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
                    const SizedBox(height: 20),
                  ],
                );
              },
            );
          } else {
            return const Center(
                child: Text("An error occurred. Please try again."));
          }
        },
      ),
      floatingActionButton: FloatingBtn(
        onPressed: () {
          // _submitResults();
        },
        icon: Icons.check,
        buttonText: '"Done',
      ),
    );
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
      showSnackBar(context, "Results saved to statistics file.");
    }
  }
}

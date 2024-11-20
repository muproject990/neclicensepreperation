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
import 'package:neclicensepreperation/features/questions/presentation/pages/AI_Chatbot/AIBOT.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/bottombar/stats.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/main_page_mcq.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/widgetHelper/AccuracyHelper.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/widgetHelper/TimerDisplay.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/widgetHelper/floating.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/widgetHelper/questionCard.dart';
import 'package:neclicensepreperation/features/questions/widgets/floating_btn.dart';
import 'package:neclicensepreperation/features/questions/widgets/optionbutton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DL extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const DL());
  const DL({super.key});

  @override
  State<DL> createState() => _DLState();
}

class _DLState extends State<DL> {
  final String data = "DL";
  int desiredQuestions = 1;
  List<String?> userAnswers = [];
  List<String> correctAnswers = [];
  List<Question> selectedQuestions = [];
  late String user;

  Timer? _timer;
  int _remainingTime = 0;
  ValueNotifier<String> _timerDisplay = ValueNotifier<String>("");

  int totalQuestions = 0;
  int correctAnswersCount = 0;
  double userAccuracy = 0.0;
  List<int> responseTimes = [];
  DateTime? questionStartTime;

  int consecutiveCorrectAnswers = 0;
  int consecutiveIncorrectAnswers = 0;
  int difficultyThreshold = 1;
  int decreaseDifficultyThreshold = 3;
  int currentPage = 0;
  final int questionsPerPage = 10;
  late int counter = 0;

  @override
  void initState() {
    super.initState();

    loadUserAccuracy();
    context.read<QuestionBloc>().add(QuestionFetchAllQuestions());
  }

  Future<void> saveUserAccuracy(double accuracy) async {
    final prefs = await SharedPreferences.getInstance();

    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      await prefs.setDouble('$data$userId', accuracy);
    }
    print("User accuracy saved successfully: $accuracy%");
  }

  Future<void> loadUserAccuracy() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserLoggedIn) {
        final userId = appUserState.user.id;
        userAccuracy = prefs.getDouble('$data$userId') ?? 0.0;
      }
    });
  }

  void _updateDifficultyBasedOnPerformance() {
    if (consecutiveCorrectAnswers >= difficultyThreshold) {
      setState(() {
        consecutiveCorrectAnswers = 0;
        userAccuracy = 90.0;
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
      _startTimer(selectedQuestions.length);
    });
  }

  List<Question> selectQuestionsByDifficulty(
      List<Question> allQuestions, int numberOfQuestions) {
    double easyThreshold = 70.0;
    double mediumThreshold = 80.0;
    double hardThreshold = 90.0;

    List<Question> filteredQuestions;

    if (userAccuracy < easyThreshold) {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'easy').toList();
      print("Selected Easy Questions - User Accuracy: $userAccuracy");
    } else if (userAccuracy < mediumThreshold) {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'medium').toList();
      print("Selected Medium Questions - User Accuracy: $userAccuracy");
    } else if (userAccuracy < hardThreshold) {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'hard').toList();
      print("Selected Hard Questions - User Accuracy: $userAccuracy");
    } else {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'very_hard').toList();
    }

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
    _timer = null; // Set to null to avoid dangling references
    _timerDisplay.dispose(); // Dispose of the ValueNotifier
    super.dispose();
  }

  void _handleOptionSelection(int index, String selectedOption) {
    setState(() {
      userAnswers[index] = selectedOption;

      if (!userAnswers.contains(null)) {
        _submitResults();
      } else {
        counter++;

        if (selectedOption == correctAnswers[index]) {
          correctAnswersCount++;
          consecutiveCorrectAnswers++;
          print(consecutiveCorrectAnswers);
          consecutiveIncorrectAnswers = 0;

          if (consecutiveCorrectAnswers >= difficultyThreshold) {
            consecutiveCorrectAnswers = 0;
            userAccuracy += 5;
            _loadNewQuestions();
          }
        } else {
          consecutiveIncorrectAnswers++;
          print(consecutiveIncorrectAnswers);
          consecutiveCorrectAnswers = 0;

          if (consecutiveIncorrectAnswers >= decreaseDifficultyThreshold) {
            consecutiveIncorrectAnswers = 0;
            userAccuracy -= 5;
            _loadNewQuestions();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProgressDisplay(
              userAccuracy: userAccuracy,
              answeredCount: counter,
              totalQuestions: selectedQuestions.length,
            ),
            TimerDisplay(
              timerDisplay: _timerDisplay,
              remainingTime: _remainingTime,
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
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
                return QuestionCard(
                  question: question,
                  userAnswer: userAnswers[index],
                  onOptionSelected: (selectedOption) =>
                      _handleOptionSelection(index, selectedOption),
                  questionIndex: index,
                );
              },
            );
          } else {
            return const Center(
                child: Text("An error occurred. Please try again."));
          }
        },
      ),
      floatingActionButton: FloatingSubmitButton(
        onSubmit: _submitResults,
      ),
    );
  }

  Future<void> _submitResults() async {
    try {
      _timer?.cancel();

      await appendResultsToStatisticsFile(
          selectedQuestions.length, correctAnswersCount, userAccuracy);
      saveUserAccuracy(userAccuracy);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StatisticsChart(
                    data: data,
                  )));
    } catch (e) {
      showSnackBar(context, "Error submitting results: ${e.toString()}");
    }
  }

  Future<void> appendResultsToStatisticsFile(
      int totalQuestions, int totalCorrectAnswers, accuracy) async {
    final directory = await getApplicationDocumentsDirectory();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      final statsFile = File('${directory.path}/${data}$userId.txt');

      double percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;
      await statsFile.writeAsString(
        'Total Questions: $totalQuestions\n'
        'Total Correct Answers: $totalCorrectAnswers\n'
        'Accuracy: $userAccuracy\n'
        'Correct: ${percentageCorrect.toStringAsFixed(2)}%\n'
        '---\n',
        mode: FileMode.append,
      );
      showSnackBar(context, "Results saved to statistics file.");
    }
  }
}

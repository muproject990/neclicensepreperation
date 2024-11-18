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
import 'package:neclicensepreperation/features/questions/presentation/pages/bottombar/stats.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/main_page_mcq.dart';
import 'package:neclicensepreperation/features/questions/widgets/floating_btn.dart';
import 'package:neclicensepreperation/features/questions/widgets/optionbutton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Programming extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const Programming());
  const Programming({super.key});

  @override
  State<Programming> createState() => _ProgrammingState();
}

class _ProgrammingState extends State<Programming> {
  final String data = "Programming";
  int desiredQuestions = 100;
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
  int difficultyThreshold = 5; // Increase difficulty after 2 correct answers
  int decreaseDifficultyThreshold =
      3; // Decrease difficulty after 3 incorrect answers
  int currentPage = 0; // Current page index
  final int questionsPerPage = 10;
  late int counter = 0;

  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(QuestionFetchProgrammingQuestions());
  }

  Future<void> saveUserAccuracy(double accuracy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('programming_accuracy', accuracy);
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
          consecutiveIncorrectAnswers = 0;
          if (consecutiveCorrectAnswers >= difficultyThreshold) {
            consecutiveCorrectAnswers = 0;
            userAccuracy += 5;
            _loadNewQuestions();
          }
        } else {
          consecutiveIncorrectAnswers++;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        // Accuracy Indicator
                        Row(
                          children: [
                            const Icon(Icons.speed,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 5),
                            Text(
                              'Accuracy: ${userAccuracy.toStringAsFixed(1)}%',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: userAccuracy < 50
                                      ? Colors.red
                                      : userAccuracy < 70
                                          ? Colors.orange
                                          : Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),

                        // Questions Answered Indicator
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 5),
                            Text(
                              'Answered: $counter/${selectedQuestions.length}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: totalQuestions <
                                          selectedQuestions.length / 2
                                      ? Colors.red
                                      : totalQuestions <
                                              selectedQuestions.length * 0.8
                                          ? Colors.orange
                                          : Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Timer Display
            ValueListenableBuilder<String>(
              valueListenable: _timerDisplay,
              builder: (context, value, child) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        color: _remainingTime < 60 ? Colors.red : Colors.white,
                        size: 20),
                    SizedBox(width: 5),
                    Text(
                      value,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              _remainingTime < 60 ? Colors.red : Colors.white),
                    ),
                  ],
                ),
              ),
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

            // Calculate the range of questions to display
            int startIndex = currentPage * questionsPerPage;
            int endIndex = startIndex + questionsPerPage;
            List<Question> questionsToDisplay = selectedQuestions.sublist(
                startIndex,
                endIndex > selectedQuestions.length
                    ? selectedQuestions.length
                    : endIndex);

            return Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: questionsToDisplay.length,
                  itemBuilder: (context, index) {
                    final question = questionsToDisplay[index];
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
                              '${startIndex + index + 1}  ${question.question.toUpperCase()}',
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
                          isCorrect: userAnswers[index] == question.answer,
                          isDisabled: userAnswers[index] != null,
                        ),
                        const SizedBox(height: 10),
                        OptionButton(
                          text: question.option2,
                          isSelected: userAnswers[index] == question.option2,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option2),
                          isCorrect: userAnswers[index] == question.answer,
                          isDisabled: userAnswers[index] != null,
                        ),
                        const SizedBox(height: 10),
                        OptionButton(
                          text: question.option3,
                          isSelected: userAnswers[index] == question.option3,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option3),
                          isCorrect: userAnswers[index] == question.answer,
                          isDisabled: userAnswers[index] != null,
                        ),
                        const SizedBox(height: 10),
                        OptionButton(
                          text: question.option4,
                          isSelected: userAnswers[index] == question.option4,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option4),
                          isCorrect: userAnswers[index] == question.answer,
                          isDisabled: userAnswers[index] != null,
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              )
            ]);
          } else {
            return const Center(
                child: Text("An error occurred. Please try again."));
          }
        },
      ),
      floatingActionButton: FloatingBtn(
        onPressed: _submitResults,
        icon: Icons.check,
        buttonText: 'Done',
      ),
    );
  }

  Future<void> _submitResults() async {
    try {
      // Stop the timer
      _timer?.cancel();

      // Append results to the statistics file
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

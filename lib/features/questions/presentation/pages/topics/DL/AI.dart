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
import 'package:neclicensepreperation/features/questions/presentation/pages/varaibles.dart';
import 'package:neclicensepreperation/features/questions/widgets/floating_btn.dart';
import 'package:neclicensepreperation/features/questions/widgets/optionbutton.dart';
import 'package:neclicensepreperation/features/questions/widgets/videoplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AI extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AI());
  const AI({super.key});

  @override
  State<AI> createState() => _AIState();
}

class _AIState extends State<AI> {
  final String data = "AI";
  double userAccuracy = 0.0;

  AllVaraibles varaibles = AllVaraibles();

  @override
  void initState() {
    super.initState();

    loadUserAccuracy();
    context.read<QuestionBloc>().add(QuestionFetchAIQuestions());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showQuestionCountDialog();
      }
    });
  }

  Future<void> saveUserAccuracy(double accuracy) async {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
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

  void _loadNewQuestions() {
    final questions = (context.read<QuestionBloc>().state).questions;
    setState(() {
      varaibles.selectedQuestions =
          selectQuestionsByDifficulty(questions, varaibles.desiredQuestions);
      varaibles.userAnswers =
          List<String?>.filled(varaibles.selectedQuestions.length, null);
      varaibles.correctAnswers =
          varaibles.selectedQuestions.map((q) => q.answer).toList();
      _startTimer(varaibles.selectedQuestions.length);
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
      varaibles.selectedQuestions =
          selectQuestionsByDifficulty(questions, varaibles.desiredQuestions);

      varaibles.userAnswers =
          List<String?>.filled(varaibles.selectedQuestions.length, null);
      varaibles.correctAnswers =
          varaibles.selectedQuestions.map((q) => q.answer).toList();
      _startTimer(varaibles.selectedQuestions.length);
    }
  }

  void _startTimer(int totalQuestions) {
    varaibles.remainingTime = totalQuestions * 20;
    _updateTimerDisplay();

    // Cancel any existing timer before starting a new one
    varaibles.timer?.cancel();

    varaibles.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        // If the widget is unmounted, cancel the timer and return early
        timer.cancel();
        return;
      }

      if (varaibles.remainingTime <= 0) {
        timer.cancel();
        if (varaibles.userAnswers.isNotEmpty) {
          showSnackBar(
              context, "Time is up! Your answers have not been submitted.");

          // Check if the widget is still mounted before navigating
          if (mounted) {
            Navigator.push(context, MCQMainPage.route());
          }
        }
      } else {
        varaibles.remainingTime--;
        _updateTimerDisplay();
      }
    });
  }

  @override
  void dispose() {
    varaibles.timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _updateTimerDisplay() {
    int minutes = varaibles.remainingTime ~/ 60;
    int seconds = varaibles.remainingTime % 60;
    varaibles.timerDisplay.value =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _handleOptionSelection(int index, String selectedOption) {
    setState(() {
      varaibles.userAnswers[index] = selectedOption;
      varaibles.counter++; // Increase counter for every answered question

      if (varaibles.counter == varaibles.desiredQuestions) {
        _submitResults(); // Submit when 20 questions are answered
        return;
      }

      if (selectedOption == varaibles.correctAnswers[index]) {
        varaibles.correctAnswersCount++;
        varaibles.consecutiveCorrectAnswers++;
        varaibles.consecutiveIncorrectAnswers = 0;

        if (varaibles.consecutiveCorrectAnswers >=
            varaibles.difficultyThreshold) {
          varaibles.consecutiveCorrectAnswers = 0;
          userAccuracy = min(userAccuracy + 5, 100.0); // Cap at 100
          _loadNewQuestions();
        }
      } else {
        varaibles.consecutiveIncorrectAnswers++;
        varaibles.consecutiveCorrectAnswers = 0;

        if (varaibles.consecutiveIncorrectAnswers >=
            varaibles.decreaseDifficultyThreshold) {
          varaibles.consecutiveIncorrectAnswers = 0;
          userAccuracy = max(userAccuracy - 5, 0.0); // Cap at 0
          _loadNewQuestions();
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
                        Row(
                          children: [
                            Icon(Icons.speed, size: 16, color: Colors.white70),
                            SizedBox(width: 5),
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
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 5),
                            Text(
                              'Answered: ${varaibles.counter}/${varaibles.selectedQuestions.length}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: varaibles.totalQuestions <
                                          varaibles.selectedQuestions.length / 2
                                      ? Colors.red
                                      : varaibles.totalQuestions <
                                              varaibles.selectedQuestions
                                                      .length *
                                                  0.8
                                          ? Colors.orange
                                          : Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.bolt,
                              color: varaibles.getDifficultyColor(userAccuracy),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Difficulty: ${varaibles.getDifficultyLevel(userAccuracy)}',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    varaibles.getDifficultyColor(userAccuracy),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ValueListenableBuilder<String>(
              valueListenable: varaibles.timerDisplay,
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
                        color: varaibles.remainingTime < 60
                            ? Colors.red
                            : Colors.white,
                        size: 20),
                    SizedBox(width: 5),
                    Text(
                      value,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: varaibles.remainingTime < 60
                              ? Colors.red
                              : Colors.white),
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
            if (varaibles.selectedQuestions.isEmpty) {
              return const Center(child: Text("No questions available."));
            }

            int startIndex = varaibles.currentPage * varaibles.questionsPerPage;
            int endIndex = startIndex + varaibles.questionsPerPage;
            List<Question> questionsToDisplay = varaibles.selectedQuestions
                .sublist(
                    startIndex,
                    endIndex > varaibles.selectedQuestions.length
                        ? varaibles.selectedQuestions.length
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
                          padding: const EdgeInsets.only(top: 20, left: 10),
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
                          isSelected:
                              varaibles.userAnswers[index] == question.option1,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option1),
                          isCorrect:
                              varaibles.userAnswers[index] == question.answer,
                          isDisabled: varaibles.userAnswers[index] != null,
                        ),
                        const SizedBox(height: 10),
                        OptionButton(
                          text: question.option2,
                          isSelected:
                              varaibles.userAnswers[index] == question.option2,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option2),
                          isCorrect:
                              varaibles.userAnswers[index] == question.answer,
                          isDisabled: varaibles.userAnswers[index] != null,
                        ),
                        const SizedBox(height: 10),
                        OptionButton(
                          text: question.option3,
                          isSelected:
                              varaibles.userAnswers[index] == question.option3,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option3),
                          isCorrect:
                              varaibles.userAnswers[index] == question.answer,
                          isDisabled: varaibles.userAnswers[index] != null,
                        ),
                        const SizedBox(height: 10),
                        OptionButton(
                          text: question.option4,
                          isSelected:
                              varaibles.userAnswers[index] == question.option4,
                          onPressed: () =>
                              _handleOptionSelection(index, question.option4),
                          isCorrect:
                              varaibles.userAnswers[index] == question.answer,
                          isDisabled: varaibles.userAnswers[index] != null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AIBOT(
                                      question.question,
                                      ' ${question.option1} ${question.option2} ${question.option3} ${question.option4}  ',
                                      question.answer,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 33, 65, 120),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Have Doubts",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoGuidePage(
                                        query: question.question),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 246, 0, 74),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Video Guide",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 55),
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
        buttonText: 'Submit',
      ),
    );
  }

  Future<void> _submitResults() async {
    try {
      varaibles.timer?.cancel();

      await appendResultsToStatisticsFile(varaibles.selectedQuestions.length,
          varaibles.correctAnswersCount, userAccuracy);
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

  Future<void> showQuestionCountDialog() async {
    int? tempCount; // Temporarily hold user input

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Desired Number of Questions"),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              tempCount = int.tryParse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (tempCount != null && tempCount! > 0) {
                  setState(() {
                    varaibles.desiredQuestions = tempCount!;
                  });
                  _loadNewQuestions(); // Load questions based on new count
                }
                Navigator.of(context).pop(); // Close dialog and save
              },
              child: Text("Start Quiz"),
            ),
          ],
        );
      },
    );
  }
}

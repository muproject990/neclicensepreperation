import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:path_provider/path_provider.dart';

class StatsFileUtils {
  static Future<void> appendResultsToFile(
    BuildContext context,
    String data,
    int totalQuestions,
    int totalCorrectAnswers,
    double userAccuracy,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      final statsFile = File('${directory.path}/${data}$userId.txt');

      double percentageCorrect = (totalCorrectAnswers / totalQuestions) * 100;
      await statsFile.writeAsString(
        'Total Questions: $totalQuestions\n'
        'Total Correct Answers: $totalCorrectAnswers\n'
        'Accuracy: ${userAccuracy.toStringAsFixed(1)}%\n'
        'Correct: ${percentageCorrect.toStringAsFixed(2)}%\n'
        '---\n',
        mode: FileMode.append,
      );
      showSnackBar(context, "Results saved to statistics file.");
    }
  }
}

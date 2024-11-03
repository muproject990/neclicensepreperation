import 'package:flutter_bloc/flutter_bloc.dart';

class CorrectAnsCubit extends Cubit<Map<String, int>> {
  CorrectAnsCubit() : super({'answered': 0, 'correct': 0});

  void incrementAnswered() {
    emit({
      'answered': state['answered']! + 1,
      'correct': state['correct']!,
    });
  }

  void incrementCorrect() {
    emit({
      'answered': state['answered']!,
      'correct': state['correct']! + 1,
    });
  }

  void decrementAnswered() {
    emit({
      'answered': state['answered']! - 1,
      'correct': state['correct']!,
    });
  }

  void decrementCorrect() {
    emit({
      'answered': state['answered']!,
      'correct': state['correct']! - 1,
    });
  }

  void increment() {}
}

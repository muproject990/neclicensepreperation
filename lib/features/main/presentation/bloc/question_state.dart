part of 'question_bloc.dart';

@immutable
sealed class QuestionState {}

final class QuestionInitial extends QuestionState {}

final class QuestionLoading extends QuestionState {}

final class QuestionFailure extends QuestionState {
  final String error;

  QuestionFailure(this.error);
}

final class QuestionSuccess extends QuestionState {}

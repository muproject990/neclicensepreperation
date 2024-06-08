import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/features/main/domain/usecases/upload_question.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final UploadQuestion uploadQuestion;
  QuestionBloc(this.uploadQuestion) : super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) => emit(QuestionLoading()));
    on<QuestionUpload>(_onQuestionUpload);
  }

  void _onQuestionUpload(
      QuestionUpload event, Emitter<QuestionState> emit) async {
    final res = await uploadQuestion(
      UploadQuestionParams(
          question: event.question,
          option1: event.option1,
          option2: event.option2,
          option3: event.option3,
          userId: event.userId,
          option4: event.option4,
          answer: event.answer,
          topics: event.topics),
    );

    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionSuccess()),
    );
  }
}

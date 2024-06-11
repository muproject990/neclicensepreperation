import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/main/domain/entities/question.dart';
import 'package:neclicensepreperation/features/main/domain/usecases/get_all_questio.dart';
import 'package:neclicensepreperation/features/main/domain/usecases/upload_question.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final UploadQuestion _uploadQuestion;
  final GetAllQuestions _getAllQuestions;
  QuestionBloc({
    required UploadQuestion uploadQuestion,
    required GetAllQuestions getAllQuestion,
  })  : _uploadQuestion = uploadQuestion,
        _getAllQuestions = getAllQuestion,
        super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) => emit(QuestionLoading()));
    on<QuestionUpload>(_onQuestionUpload);
    on<QuestionFetchAllQuestions>(_onFetchAllQuestions);
  }

  void _onQuestionUpload(
      QuestionUpload event, Emitter<QuestionState> emit) async {
    final res = await _uploadQuestion(
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
      (r) => emit(QuestionUploadSuccess()),
    );
  }

  void _onFetchAllQuestions(
    QuestionFetchAllQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getAllQuestions(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }
}

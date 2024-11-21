import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_programming_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_questio.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_dsa_questios.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_toc_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/upload_question.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final UploadQuestion _uploadQuestion;
  final GetAllQuestions _getAllQuestions;
  final GetTocQuestions _getTocQuestions;
  final GetAllProgrammingQuestions _getProgrammingQuestions;
  final GetDsaQuestions _getDsaQuestions;
  QuestionBloc({
    required UploadQuestion uploadQuestion,
    required GetAllQuestions getAllQuestion,
    required GetTocQuestions get_toc_question,
    required GetDsaQuestions get_dsa_questions,
    required GetAllProgrammingQuestions get_programming_questions,
  })  : _uploadQuestion = uploadQuestion,
        _getAllQuestions = getAllQuestion,
        _getTocQuestions = get_toc_question,
        _getDsaQuestions = get_dsa_questions,
        _getProgrammingQuestions = get_programming_questions,
        super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) => emit(QuestionLoading()));
    on<QuestionUpload>(_onQuestionUpload);
    on<QuestionFetchAllQuestions>(_onFetchAllQuestions);
    on<QuestionFetchProgrammingQuestions>(_onFetchProgrammingQuestions);
    on<QuestionFetchTocQuestions>(_onFetchTocQuestions);
    on<QuestionFetchDsaQuestions>(_onFetchDsaQuestions);
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
          topics: event.topics,
          difficulty: ''),
      // Todo modification needed here
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

  void _onFetchProgrammingQuestions(
    QuestionFetchProgrammingQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getProgrammingQuestions(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }

  void _onFetchTocQuestions(
    QuestionFetchTocQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getTocQuestions(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }

  void _onFetchDsaQuestions(
    QuestionFetchDsaQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getDsaQuestions(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }
}

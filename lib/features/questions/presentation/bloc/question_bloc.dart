import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_questio.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_dsa_questios.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_network_questios.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_programming_questios.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_toc_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/upload_question.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final UploadQuestion _uploadQuestion;
  final GetAllQuestions _getAllQuestions;
  final GetProgrammingQuestions _getProgrammingQuestions;
  final GetNetworkQuestios _getNetworkQuestios;

  QuestionBloc(
      {required UploadQuestion uploadQuestion,
      required GetAllQuestions getAllQuestion,
      required GetProgrammingQuestions getProgrammingQuestions,
      required GetNetworkQuestios getNetworkQuestions})
      : _uploadQuestion = uploadQuestion,
        _getAllQuestions = getAllQuestion,
        _getProgrammingQuestions = getProgrammingQuestions,
        _getNetworkQuestios = getNetworkQuestions,
        super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) => emit(QuestionLoading()));
    on<QuestionUpload>(_onQuestionUpload);
    on<QuestionFetchAllQuestions>(_onFetchAllQuestions);
    on<QuestionFetchProgrammingQuestions>(_onFetchProgrammingQuestions);
    on<QuestionFetchNetworkQuestions>(_onFetchNetworkQuestions);
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

  void _onFetchNetworkQuestions(
    QuestionFetchNetworkQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getNetworkQuestios(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }
}

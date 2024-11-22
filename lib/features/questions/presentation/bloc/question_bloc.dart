import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_ai_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_programming_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_questio.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_coa_q.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_proj_planning_q.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_toc_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/upload_question.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final UploadQuestion _uploadQuestion;
  final GetAllQuestions _getAllQuestions;
  final GetAllProgrammingQuestions _getProgrammingQuestions;
  final GetAllTocQuestion _getAllTocQuestion;
  final GetAllAiQuestion _getAllAiQuestion;
  final GetAllCOAQuestion _getAllCOAQuestion;
  final GetProjPlanningQ _getProjPlanningQ;

  QuestionBloc({
    required UploadQuestion uploadQuestion,
    required GetAllTocQuestion getAllTocQuestion,
    required GetAllQuestions getAllQuestion,
    required GetAllProgrammingQuestions getprogrammingquestions,
    required GetAllAiQuestion getAllAiQuestion,
    required GetAllCOAQuestion getAllCOAQuestion,
    required GetProjPlanningQ getProjectPlanningQuestion,
  })  : _uploadQuestion = uploadQuestion,
        _getAllTocQuestion = getAllTocQuestion,
        _getAllQuestions = getAllQuestion,
        _getProgrammingQuestions = getprogrammingquestions,
        _getAllAiQuestion = getAllAiQuestion,
        _getAllCOAQuestion = getAllCOAQuestion,
        _getProjPlanningQ = getProjectPlanningQuestion,
        super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) => emit(QuestionLoading()));
    on<QuestionUpload>(_onQuestionUpload);
    on<QuestionFetchTocQuestions>(_onFetchTocQuestions);
    on<QuestionFetchAllQuestions>(_onFetchAllQuestions);
    on<QuestionFetchProgrammingQuestions>(_onFetchProgrammingQuestions);
    on<QuestionFetchAIQuestions>(_onFetchAIQuestions);
    on<QuestionFetchCOAQuestions>(_onFetchCOAQuestions);
    on<QuestionFetchNETWORKQuestions>(_onFetchNetworkQuestions);
    on<QuestionFetchProjectPlanningQuestions>(_onFetchProjPlanningQuestions);
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

  void _onFetchAIQuestions(
    QuestionFetchAIQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getAllAiQuestion(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }

  void _onFetchCOAQuestions(
    QuestionFetchCOAQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getAllCOAQuestion(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }

  void _onFetchNetworkQuestions(
    QuestionFetchNETWORKQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getAllCOAQuestion(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }

  void _onFetchProjPlanningQuestions(
    QuestionFetchProjectPlanningQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getProjPlanningQ(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }

  void _onFetchTocQuestions(
    QuestionFetchTocQuestions event,
    Emitter<QuestionState> emit,
  ) async {
    final res = await _getAllTocQuestion(NoParams());
    res.fold(
      (l) => emit(QuestionFailure(l.message)),
      (r) => emit(QuestionDisplaySuccess(r)),
    );
  }
}

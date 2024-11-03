import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/features/questions/data/models/question_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class QuestionRemoteDataSource {
  Future<QuestionModel> uploadQuestion(QuestionModel question);
  Future<List<QuestionModel>> getAllQuestion();
  Future<List<QuestionModel>> getTocQuestion();
  Future<List<QuestionModel>> getDsaQuestion();
  Future<List<QuestionModel>> getProgrammingQuestions();
}

class QuestionRemoteDataSourceImpl implements QuestionRemoteDataSource {
  final SupabaseClient supabaseClient;

  QuestionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<QuestionModel> uploadQuestion(QuestionModel question) async {
    try {
      final quesData = await supabaseClient
          .from('addquestions')
          .insert(question.toJson())
          .select();

      // print(quesData.first);
      return QuestionModel.fromJson(quesData.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getAllQuestion() async {
    try {
      final questions = await supabaseClient
          .from('addquestions')
          .select("*")
          .contains('topics', ['Microprocessor']);

      return questions.map((ques) => QuestionModel.fromJson(ques)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<QuestionModel>> getAllMicro() async {
    try {
      final questions = await supabaseClient
          .from('addquestions')
          .select("*")
          .contains('topics', ['Microprocessor']);

      return questions.map((ques) => QuestionModel.fromJson(ques)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getTocQuestion() async {
    try {
      final questions = await supabaseClient
          .from('addquestions')
          .select("*")
          .contains('topics', ['TOC']);

      return questions.map((ques) => QuestionModel.fromJson(ques)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getDsaQuestion() async {
    try {
      final questions = await supabaseClient
          .from('addquestions')
          .select("*")
          .contains('topics', ['DSA']);

      return questions.map((ques) => QuestionModel.fromJson(ques)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getProgrammingQuestions() async {
    try {
      final questions = await supabaseClient
          .from('addquestions')
          .select("*")
          .contains('topics', ['Programming']);

      return questions.map((ques) => QuestionModel.fromJson(ques)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:neclicensepreperation/features/main/data/models/question_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class QuestionRemoteDataSource {
  Future<QuestionModel> uploadQuestion(QuestionModel question);
  Future<List<QuestionModel>> getAllQuestion();
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

  // @override
  // Future<QuestionModel> getAllQuestion(QuestionModel question) {
  //   // TODO: implement getAllQuestion
  //   throw UnimplementedError();
  // }

  @override
  Future<List<QuestionModel>> getAllQuestion() async {
    try {
      final questions = await supabaseClient
          .from('addquestions')
          .select("*")
          .contains('topics', ['Technology']);

      return questions.map((ques) => QuestionModel.fromJson(ques)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/features/main/data/models/question_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class QuestionRemoteDataSource {
  Future<QuestionModel> uploadQuestion(QuestionModel question);
}

class QuestionRemoteDataSourceImpl implements QuestionRemoteDataSource {
  final SupabaseClient supabaseClient;

  QuestionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<QuestionModel> uploadQuestion(QuestionModel question) async {
    try {
      final quesData =
          await supabaseClient.from('addquestions').insert(question.toJson());
      return QuestionModel.fromJson(quesData.first); 
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/main/domain/entities/question.dart';

abstract interface class QuestionRepository {
  Future<Either<Failure, Question>> uploadQuestion({
    required String question,
    required String option1,
    required String option2,
    required String option3,
    required String userId,
    required String option4,
    required String answer,
    required List<String> topics,
  });
}

import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/repositories/question_repo.dart';

class UploadQuestion implements UseCase<Question, UploadQuestionParams> {
  final QuestionRepository questionRepository;

  UploadQuestion({required this.questionRepository});
  @override
  Future<Either<Failure, Question>> call(UploadQuestionParams params) async {
    return await questionRepository.uploadQuestion(
      question: params.question,
      option1: params.option1,
      option2: params.option2,
      option3: params.option3,
      userId: params.userId,
      option4: params.option4,
      answer: params.answer,
      topics: params.topics,
      difficulty: params.difficulty,
    );
  }
}

class UploadQuestionParams {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String userId;
  final String option4;
  final String answer;
  final List<String> topics;
  final String difficulty;

  UploadQuestionParams({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.userId,
    required this.option4,
    required this.answer,
    required this.topics,
    required this.difficulty,
  });
}

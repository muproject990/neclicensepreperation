import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/questions/data/datasources/question_remote_data_source.dart';
import 'package:neclicensepreperation/features/questions/data/models/question_model.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/repositories/question_repo.dart';
import 'package:uuid/uuid.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDataSource questionRemoteDataSource;
  QuestionRepositoryImpl(this.questionRemoteDataSource);

  @override
  Future<Either<Failure, Question>> uploadQuestion({
    required String question,
    required String option1,
    required String userId,
    required String option2,
    required String option3,
    required String option4,
    required String answer,
    required List<String> topics,
    required String difficulty, // New parameter
  }) async {
    try {
      QuestionModel questionModel = QuestionModel(
        id: const Uuid().v4(),
        userId: userId,
        question: question,
        option1: option1,
        option2: option2,
        option3: option3,
        option4: option4,
        answer: answer,
        topics: topics,
        updatedAt: DateTime.now(),
        difficulty: difficulty, // Set the difficulty level
      );

      final uploadedQuestion =
          await questionRemoteDataSource.uploadQuestion(questionModel);
      return right(uploadedQuestion);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getAllQuestion() async {
    try {
      final question = await questionRemoteDataSource.getAllQuestion();
      return right(question);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getProgrammingQuestions() async {
    try {
      final question = await questionRemoteDataSource.getProgrammingQuestions();
      return right(question);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getTocQuestions() async {
    try {
      final question = await questionRemoteDataSource.getTocQuestion();
      return right(question);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getDsaQuestions() async {
    try {
      final question = await questionRemoteDataSource.getDsaQuestion();
      return right(question);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

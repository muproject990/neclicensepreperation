import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/repositories/question_repo.dart';

class GetAllQuestions implements UseCase<List<Question>, NoParams> {
  final QuestionRepository questionRepository;
  GetAllQuestions(this.questionRepository);

  @override
  Future<Either<Failure, List<Question>>> call(NoParams params) async {
    return await questionRepository.getAllQuestion();
  }
}
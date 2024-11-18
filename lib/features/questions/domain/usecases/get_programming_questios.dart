import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';
import 'package:neclicensepreperation/features/questions/domain/repositories/question_repo.dart';

class GetProgrammingQuestions implements UseCase<List<Question>, NoParams> {
  final QuestionRepository questionRepository;
  GetProgrammingQuestions(this.questionRepository);

  @override
  Future<Either<Failure, List<Question>>> call(NoParams params) async {
    return await questionRepository.getProgrammingQuestions();
  }
}

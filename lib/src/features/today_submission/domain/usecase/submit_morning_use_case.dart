import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/today_submission_repository.dart';

class SubmitMorningUseCase extends UseCase<void, NoParams> {
  const SubmitMorningUseCase({required this.repository});

  final TodaySubmissionRepository repository;

  @override
  Future<Either<AppFailure, void>> execute(NoParams params) async {
    try {
      await repository.submitMorning();
      return const Either.right(null);
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../entity/today_submission_snapshot.dart';
import '../repository/today_submission_repository.dart';

class GetTodaySubmissionUseCase
    extends UseCase<TodaySubmissionSnapshot, NoParams> {
  const GetTodaySubmissionUseCase({required this.repository});

  final TodaySubmissionRepository repository;

  @override
  Future<Either<AppFailure, TodaySubmissionSnapshot>> execute(
    NoParams params,
  ) async {
    try {
      return Either.right(await repository.getTodaySubmission());
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

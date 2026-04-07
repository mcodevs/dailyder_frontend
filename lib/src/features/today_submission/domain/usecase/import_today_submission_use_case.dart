import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/today_submission_repository.dart';

class ImportTodaySubmissionUseCase extends UseCase<bool, String> {
  const ImportTodaySubmissionUseCase({required this.repository});

  final TodaySubmissionRepository repository;

  @override
  Future<Either<AppFailure, bool>> execute(String params) async {
    try {
      return Either.right(await repository.importDraft(params));
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

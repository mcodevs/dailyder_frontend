import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/today_submission_repository.dart';

class DeleteDraftItemUseCase extends UseCase<bool, String> {
  const DeleteDraftItemUseCase({required this.repository});

  final TodaySubmissionRepository repository;

  @override
  Future<Either<AppFailure, bool>> execute(String params) async {
    try {
      return Either.right(await repository.deleteDraftItem(params));
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/today_submission_repository.dart';

class SaveDraftItemParams {
  const SaveDraftItemParams({
    this.itemId,
    required this.projectName,
    required this.taskName,
    required this.subtaskNames,
  });

  final String? itemId;
  final String projectName;
  final String taskName;
  final List<String> subtaskNames;
}

class SaveDraftItemUseCase extends UseCase<bool, SaveDraftItemParams> {
  const SaveDraftItemUseCase({required this.repository});

  final TodaySubmissionRepository repository;

  @override
  Future<Either<AppFailure, bool>> execute(SaveDraftItemParams params) async {
    try {
      return Either.right(
        await repository.saveDraftItem(
          itemId: params.itemId,
          projectName: params.projectName,
          taskName: params.taskName,
          subtaskNames: params.subtaskNames,
        ),
      );
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

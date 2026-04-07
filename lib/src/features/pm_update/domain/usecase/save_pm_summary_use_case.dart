import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/pm_update_repository.dart';

class SavePmSummaryParams {
  const SavePmSummaryParams({
    required this.itemStatuses,
    required this.subtaskStatuses,
    this.finalNote,
  });

  final List<ItemStatusPayload> itemStatuses;
  final List<SubtaskStatusPayload> subtaskStatuses;
  final String? finalNote;
}

class SavePmSummaryUseCase extends UseCase<void, SavePmSummaryParams> {
  const SavePmSummaryUseCase({required this.repository});

  final PmUpdateRepository repository;

  @override
  Future<Either<AppFailure, void>> execute(SavePmSummaryParams params) async {
    try {
      await repository.savePmSummary(
        itemStatuses: params.itemStatuses,
        subtaskStatuses: params.subtaskStatuses,
        finalNote: params.finalNote,
      );
      return const Either.right(null);
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

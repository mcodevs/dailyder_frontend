import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../entity/pm_summary.dart';
import '../repository/pm_update_repository.dart';

class GetPmSummaryUseCase extends UseCase<PmSummary, NoParams> {
  const GetPmSummaryUseCase({required this.repository});

  final PmUpdateRepository repository;

  @override
  Future<Either<AppFailure, PmSummary>> execute(NoParams params) async {
    try {
      return Either.right(await repository.getPmSummary());
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

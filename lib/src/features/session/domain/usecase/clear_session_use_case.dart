import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/session_repository.dart';

class ClearSessionUseCase extends UseCase<void, NoParams> {
  const ClearSessionUseCase({required this.repository});

  final SessionRepository repository;

  @override
  Future<Either<AppFailure, void>> execute(NoParams params) async {
    try {
      await repository.clearAccessToken();
      return const Either.right(null);
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

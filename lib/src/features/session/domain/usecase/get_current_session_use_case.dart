import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/session_repository.dart';

class GetCurrentSessionUseCase extends UseCase<SessionUser, NoParams> {
  const GetCurrentSessionUseCase({required this.repository});

  final SessionRepository repository;

  @override
  Future<Either<AppFailure, SessionUser>> execute(NoParams params) async {
    try {
      return Either.right(await repository.getCurrentUser());
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

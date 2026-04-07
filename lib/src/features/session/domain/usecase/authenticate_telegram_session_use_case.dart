import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/session_repository.dart';

class AuthenticateTelegramSessionUseCase extends UseCase<String, String> {
  const AuthenticateTelegramSessionUseCase({required this.repository});

  final SessionRepository repository;

  @override
  Future<Either<AppFailure, String>> execute(String params) async {
    try {
      return Either.right(
        await repository.authenticateWithTelegram(initData: params),
      );
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

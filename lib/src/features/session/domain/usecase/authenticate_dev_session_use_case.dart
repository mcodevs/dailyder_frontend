import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/session_repository.dart';

class DevSessionParams {
  const DevSessionParams({this.username, this.telegramUserId});

  final String? username;
  final int? telegramUserId;
}

class AuthenticateDevSessionUseCase extends UseCase<String, DevSessionParams> {
  const AuthenticateDevSessionUseCase({required this.repository});

  final SessionRepository repository;

  @override
  Future<Either<AppFailure, String>> execute(DevSessionParams params) async {
    try {
      return Either.right(
        await repository.authenticateWithDevLogin(
          username: params.username,
          telegramUserId: params.telegramUserId,
        ),
      );
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

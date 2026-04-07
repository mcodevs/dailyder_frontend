import '../../../../common/data/either/either.dart';
import '../../../../common/data/failure/app_failure.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../repository/session_repository.dart';

class SaveAccessTokenUseCase extends UseCase<void, String> {
  const SaveAccessTokenUseCase({required this.repository});

  final SessionRepository repository;

  @override
  Future<Either<AppFailure, void>> execute(String params) async {
    try {
      await repository.saveAccessToken(params);
      return const Either.right(null);
    } on Object catch (error) {
      return Either.left(mapExceptionToFailure(error));
    }
  }
}

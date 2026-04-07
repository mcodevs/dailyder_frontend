import '../either/either.dart';
import '../failure/app_failure.dart';

abstract class UseCase<R, P> {
  const UseCase();

  Future<Either<AppFailure, R>> execute(P params);
}

class NoParams {
  const NoParams();
}

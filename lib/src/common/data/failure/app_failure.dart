import '../../../core/network/api_exception.dart';

class AppFailure {
  const AppFailure(this.message);

  final String message;
}

class ApiFailure extends AppFailure {
  const ApiFailure(super.message, {this.statusCode});

  final int? statusCode;
}

class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure(super.message);
}

AppFailure mapExceptionToFailure(Object error) {
  if (error is ApiException) {
    return ApiFailure(error.message, statusCode: error.statusCode);
  }
  return UnexpectedFailure(error.toString());
}

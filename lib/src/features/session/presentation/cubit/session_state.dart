import 'package:equatable/equatable.dart';

import '../../../../common/data/enums/status.dart';
import '../../domain/entity/session_user.dart';

class SessionState extends Equatable {
  const SessionState({
    required this.status,
    required this.devAuthEnabled,
    required this.telegramEnvironment,
    this.user,
    this.errorMessage,
  });

  final Status status;
  final SessionUser? user;
  final String? errorMessage;
  final bool devAuthEnabled;
  final bool telegramEnvironment;

  bool get isAuthenticated => user != null;

  SessionState copyWith({
    Status? status,
    SessionUser? user,
    bool clearUser = false,
    String? errorMessage,
  }) {
    return SessionState(
      status: status ?? this.status,
      devAuthEnabled: devAuthEnabled,
      telegramEnvironment: telegramEnvironment,
      user: clearUser ? null : user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    devAuthEnabled,
    telegramEnvironment,
  ];
}

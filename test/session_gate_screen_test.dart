import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailyder_frontend/src/core/env/app_environment.dart';
import 'package:dailyder_frontend/src/core/telegram/telegram_web_app_bridge.dart';
import 'package:dailyder_frontend/src/features/session/domain/entity/session_user.dart';
import 'package:dailyder_frontend/src/features/session/domain/repository/session_repository.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/authenticate_dev_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/authenticate_telegram_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/clear_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/get_current_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/save_access_token_use_case.dart';
import 'package:dailyder_frontend/src/features/session/presentation/cubit/session_cubit.dart';
import 'package:dailyder_frontend/src/features/session/presentation/screen/session_gate_screen.dart';

class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository({this.token = '', this.user});

  String token;
  SessionUser? user;

  @override
  String get accessToken => token;

  @override
  Future<String> authenticateWithDevLogin({
    String? username,
    int? telegramUserId,
  }) async {
    token = 'dev-token';
    return token;
  }

  @override
  Future<String> authenticateWithTelegram({required String initData}) async {
    token = 'telegram-token';
    return token;
  }

  @override
  Future<void> clearAccessToken() async {
    token = '';
  }

  @override
  Future<SessionUser> getCurrentUser() async {
    if (user == null) {
      throw Exception('no session');
    }
    return user!;
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    token = accessToken;
  }
}

void main() {
  testWidgets(
    'SessionGateScreen shows dev login form when no token is available',
    (tester) async {
      final repository = FakeSessionRepository();
      final cubit = SessionCubit(
        environment: const AppEnvironment(
          apiBaseUrl: 'http://localhost:8080',
          devAuthEnabled: true,
        ),
        telegramWebAppBridge: TelegramWebAppBridge(),
        sessionRepository: repository,
        getCurrentSessionUseCase: GetCurrentSessionUseCase(
          repository: repository,
        ),
        authenticateTelegramSessionUseCase: AuthenticateTelegramSessionUseCase(
          repository: repository,
        ),
        authenticateDevSessionUseCase: AuthenticateDevSessionUseCase(
          repository: repository,
        ),
        saveAccessTokenUseCase: SaveAccessTokenUseCase(repository: repository),
        clearSessionUseCase: ClearSessionUseCase(repository: repository),
      );

      await cubit.bootstrap();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const SessionGateScreen(),
          ),
        ),
      );

      expect(find.text('Dev login'), findsOneWidget);
      expect(find.text('Dailyder Mini App'), findsOneWidget);
    },
  );
}

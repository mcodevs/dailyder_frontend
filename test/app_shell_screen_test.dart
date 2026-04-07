import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailyder_frontend/src/core/env/app_environment.dart';
import 'package:dailyder_frontend/src/core/navigation/app_route_paths.dart';
import 'package:dailyder_frontend/src/core/telegram/telegram_web_app_bridge.dart';
import 'package:dailyder_frontend/src/features/app_shell/presentation/screen/app_shell_screen.dart';
import 'package:dailyder_frontend/src/features/session/domain/entity/session_user.dart';
import 'package:dailyder_frontend/src/features/session/domain/repository/session_repository.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/authenticate_dev_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/authenticate_telegram_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/clear_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/get_current_session_use_case.dart';
import 'package:dailyder_frontend/src/features/session/domain/usecase/save_access_token_use_case.dart';
import 'package:dailyder_frontend/src/features/session/presentation/cubit/session_cubit.dart';

class FakeAuthenticatedSessionRepository implements SessionRepository {
  @override
  String get accessToken => 'token';

  @override
  Future<String> authenticateWithDevLogin({
    String? username,
    int? telegramUserId,
  }) async => 'token';

  @override
  Future<String> authenticateWithTelegram({required String initData}) async =>
      'token';

  @override
  Future<void> clearAccessToken() async {}

  @override
  Future<SessionUser> getCurrentUser() async {
    return const SessionUser(
      telegramUserId: 9001,
      displayName: 'Admin User',
      isAdmin: true,
      isOnboarded: true,
      isGroupBound: true,
      isGroupMember: true,
      authMode: 'dev',
      username: 'adminuser',
    );
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {}
}

void main() {
  testWidgets('AppShellScreen shows navigation items on wide layouts', (
    tester,
  ) async {
    final repository = FakeAuthenticatedSessionRepository();
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

    await cubit.loadCurrentUser();

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1400, 900)),
        child: MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const AppShellScreen(
              currentLocation: AppRoutePaths.today,
              child: Placeholder(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Bugungi tasklar'), findsOneWidget);
    expect(find.text('Group binding'), findsOneWidget);
  });
}

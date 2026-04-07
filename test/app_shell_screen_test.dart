import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:dailyder_frontend/src/core/env/app_environment.dart';
import 'package:dailyder_frontend/src/core/navigation/app_route_paths.dart';
import 'package:dailyder_frontend/src/core/telegram/telegram_web_app_bridge.dart';
import 'package:dailyder_frontend/src/core/theme/app_theme.dart';
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
    final cubit = await buildAuthenticatedSessionCubit();

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1400, 900)),
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp.router(
            routerConfig: buildShellRouter(),
            theme: AppTheme.light(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bugungi tasklar'), findsOneWidget);
    expect(find.text('Group binding'), findsOneWidget);
    expect(find.text('Today body'), findsOneWidget);
  });

  testWidgets('AppShellScreen closes mobile drawer before navigation', (
    tester,
  ) async {
    final cubit = await buildAuthenticatedSessionCubit();

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp.router(
            routerConfig: buildShellRouter(),
            theme: AppTheme.light(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isTrue,
    );

    await tester.tap(find.text('Yordam'));
    await tester.pumpAndSettle();

    expect(find.text('Help body'), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
  });

  testWidgets('AppShellScreen closes mobile drawer on sign out', (
    tester,
  ) async {
    final cubit = await buildAuthenticatedSessionCubit();

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp.router(
            routerConfig: buildShellRouter(),
            theme: AppTheme.light(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chiqish'));
    await tester.pumpAndSettle();

    expect(find.text('Root body'), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
  });
}

Future<SessionCubit> buildAuthenticatedSessionCubit() async {
  final repository = FakeAuthenticatedSessionRepository();
  final cubit = SessionCubit(
    environment: const AppEnvironment(
      apiBaseUrl: 'http://localhost:8080',
      devAuthEnabled: true,
    ),
    telegramWebAppBridge: TelegramWebAppBridge(),
    sessionRepository: repository,
    getCurrentSessionUseCase: GetCurrentSessionUseCase(repository: repository),
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
  return cubit;
}

GoRouter buildShellRouter() {
  return GoRouter(
    initialLocation: AppRoutePaths.today,
    routes: [
      GoRoute(
        path: AppRoutePaths.root,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Root body'))),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShellScreen(currentLocation: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutePaths.today,
            builder: (context, state) =>
                const Center(child: Text('Today body')),
          ),
          GoRoute(
            path: AppRoutePaths.help,
            builder: (context, state) => const Center(child: Text('Help body')),
          ),
        ],
      ),
    ],
  );
}

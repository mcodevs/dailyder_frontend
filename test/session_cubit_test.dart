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
import 'package:flutter_test/flutter_test.dart';

class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository({this.user});

  SessionUser? user;
  String token = '';
  String? lastTelegramInitData;

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
    lastTelegramInitData = initData;
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

class FakeTelegramWebAppBridge extends TelegramWebAppBridge {
  FakeTelegramWebAppBridge({
    required this.availableAfterWait,
    required this.initDataAfterWait,
  });

  final bool availableAfterWait;
  final String initDataAfterWait;

  bool readyCalled = false;
  bool expandCalled = false;
  bool waitCalled = false;

  @override
  bool get isAvailable => waitCalled && availableAfterWait;

  @override
  String get initData => waitCalled ? initDataAfterWait : '';

  @override
  Future<String> waitForInitData({
    Duration timeout = const Duration(seconds: 2),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    waitCalled = true;
    return initDataAfterWait;
  }

  @override
  void ready() {
    readyCalled = true;
  }

  @override
  void expand() {
    expandCalled = true;
  }
}

void main() {
  test('bootstrap authenticates with delayed Telegram init data', () async {
    final repository = FakeSessionRepository(
      user: const SessionUser(
        telegramUserId: 9001,
        displayName: 'Telegram User',
        isAdmin: false,
        isOnboarded: true,
        isGroupBound: true,
        isGroupMember: true,
        authMode: 'telegram',
        username: 'telegram_user',
      ),
    );
    final telegramBridge = FakeTelegramWebAppBridge(
      availableAfterWait: true,
      initDataAfterWait: 'query_id=123',
    );
    final cubit = SessionCubit(
      environment: const AppEnvironment(
        apiBaseUrl: 'https://dailyder-bot.fly.dev',
        devAuthEnabled: false,
      ),
      telegramWebAppBridge: telegramBridge,
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

    expect(repository.lastTelegramInitData, 'query_id=123');
    expect(repository.accessToken, 'telegram-token');
    expect(telegramBridge.readyCalled, isTrue);
    expect(telegramBridge.expandCalled, isTrue);
    expect(cubit.state.telegramEnvironment, isTrue);
    expect(cubit.state.isAuthenticated, isTrue);
  });
}

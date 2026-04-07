import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/enums/status.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../../../../core/env/app_environment.dart';
import '../../../../core/telegram/telegram_web_app_bridge.dart';
import '../../domain/repository/session_repository.dart';
import '../../domain/usecase/authenticate_dev_session_use_case.dart';
import '../../domain/usecase/authenticate_telegram_session_use_case.dart';
import '../../domain/usecase/clear_session_use_case.dart';
import '../../domain/usecase/get_current_session_use_case.dart';
import '../../domain/usecase/save_access_token_use_case.dart';
import '../cubit/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required this.environment,
    required this.telegramWebAppBridge,
    required this.sessionRepository,
    required this.getCurrentSessionUseCase,
    required this.authenticateTelegramSessionUseCase,
    required this.authenticateDevSessionUseCase,
    required this.saveAccessTokenUseCase,
    required this.clearSessionUseCase,
  }) : super(
         SessionState(
           status: Status.initial,
           devAuthEnabled: environment.devAuthEnabled,
           telegramEnvironment: telegramWebAppBridge.isAvailable,
         ),
       );

  final AppEnvironment environment;
  final TelegramWebAppBridge telegramWebAppBridge;
  final SessionRepository sessionRepository;
  final GetCurrentSessionUseCase getCurrentSessionUseCase;
  final AuthenticateTelegramSessionUseCase authenticateTelegramSessionUseCase;
  final AuthenticateDevSessionUseCase authenticateDevSessionUseCase;
  final SaveAccessTokenUseCase saveAccessTokenUseCase;
  final ClearSessionUseCase clearSessionUseCase;

  Future<void> bootstrap() async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    final initialTelegramEnvironment = telegramWebAppBridge.isAvailable;
    final initData = await telegramWebAppBridge.waitForInitData();
    final telegramEnvironment =
        initialTelegramEnvironment ||
        initData.trim().isNotEmpty ||
        telegramWebAppBridge.isAvailable;
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        telegramEnvironment: telegramEnvironment,
      ),
    );
    if (initData.isNotEmpty) {
      telegramWebAppBridge.ready();
      telegramWebAppBridge.expand();
      final authResult = await authenticateTelegramSessionUseCase.execute(
        initData,
      );
      await authResult.fold(
        onLeft: (failure) async {
          emit(
            state.copyWith(status: Status.error, errorMessage: failure.message),
          );
        },
        onRight: (accessToken) async {
          await saveAccessTokenUseCase.execute(accessToken);
          await loadCurrentUser();
        },
      );
      return;
    }
    if (telegramEnvironment) {
      emit(
        state.copyWith(
          status: Status.error,
          clearUser: true,
          errorMessage:
              'Telegram sessiyasi topilmadi. Mini Appni Telegram ichidan qayta oching.',
          telegramEnvironment: true,
        ),
      );
      return;
    }
    if (sessionRepository.accessToken.isEmpty) {
      emit(
        state.copyWith(
          status: Status.success,
          clearUser: true,
          errorMessage: null,
        ),
      );
      return;
    }
    await loadCurrentUser(silentFailure: true);
  }

  Future<void> loadCurrentUser({bool silentFailure = false}) async {
    final result = await getCurrentSessionUseCase.execute(const NoParams());
    await result.fold(
      onLeft: (failure) async {
        if (silentFailure) {
          await clearSessionUseCase.execute(const NoParams());
        }
        emit(
          state.copyWith(
            status: Status.success,
            clearUser: true,
            errorMessage: silentFailure ? null : failure.message,
          ),
        );
      },
      onRight: (user) async {
        emit(
          state.copyWith(
            status: Status.success,
            user: user,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> signInWithDevInput({
    required String username,
    required String telegramUserIdText,
  }) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    final parsedTelegramUserId = int.tryParse(telegramUserIdText.trim());
    final result = await authenticateDevSessionUseCase.execute(
      DevSessionParams(
        username: username.trim().isEmpty ? null : username.trim(),
        telegramUserId: parsedTelegramUserId,
      ),
    );
    await result.fold(
      onLeft: (failure) async {
        emit(
          state.copyWith(status: Status.error, errorMessage: failure.message),
        );
      },
      onRight: (accessToken) async {
        await saveAccessTokenUseCase.execute(accessToken);
        await loadCurrentUser(silentFailure: false);
      },
    );
  }

  Future<void> signOut() async {
    await clearSessionUseCase.execute(const NoParams());
    emit(
      state.copyWith(
        status: Status.success,
        clearUser: true,
        errorMessage: null,
      ),
    );
  }
}

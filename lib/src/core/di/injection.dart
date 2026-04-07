import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/admin_console/data/repository/admin_console_repository_impl.dart';
import '../../features/admin_console/domain/repository/admin_console_repository.dart';
import '../../features/admin_console/presentation/cubit/admin_console_cubit.dart';
import '../../features/pm_update/data/repository/pm_update_repository_impl.dart';
import '../../features/pm_update/domain/repository/pm_update_repository.dart';
import '../../features/pm_update/domain/usecase/get_pm_summary_use_case.dart';
import '../../features/pm_update/domain/usecase/save_pm_summary_use_case.dart';
import '../../features/pm_update/presentation/cubit/pm_update_cubit.dart';
import '../../features/session/data/repository/session_local_store.dart';
import '../../features/session/data/repository/session_repository_impl.dart';
import '../../features/session/domain/repository/session_repository.dart';
import '../../features/session/domain/usecase/authenticate_dev_session_use_case.dart';
import '../../features/session/domain/usecase/authenticate_telegram_session_use_case.dart';
import '../../features/session/domain/usecase/clear_session_use_case.dart';
import '../../features/session/domain/usecase/get_current_session_use_case.dart';
import '../../features/session/domain/usecase/save_access_token_use_case.dart';
import '../../features/session/presentation/cubit/session_cubit.dart';
import '../../features/today_submission/data/repository/today_submission_repository_impl.dart';
import '../../features/today_submission/domain/repository/today_submission_repository.dart';
import '../../features/today_submission/domain/usecase/delete_draft_item_use_case.dart';
import '../../features/today_submission/domain/usecase/get_today_submission_use_case.dart';
import '../../features/today_submission/domain/usecase/import_today_submission_use_case.dart';
import '../../features/today_submission/domain/usecase/save_draft_item_use_case.dart';
import '../../features/today_submission/domain/usecase/submit_morning_use_case.dart';
import '../../features/today_submission/presentation/cubit/today_submission_cubit.dart';
import '../env/app_environment.dart';
import '../network/api_client.dart';
import '../telegram/telegram_web_app_bridge.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(AppEnvironment.current);
  sl.registerLazySingleton(TelegramWebAppBridge.new);
  sl.registerLazySingleton(() => SessionLocalStore(preferences: preferences));
  sl.registerLazySingleton(
    () => ApiClient(
      environment: sl<AppEnvironment>(),
      sessionLocalStore: sl<SessionLocalStore>(),
    ),
  );

  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(
      apiClient: sl<ApiClient>(),
      sessionLocalStore: sl<SessionLocalStore>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetCurrentSessionUseCase(repository: sl<SessionRepository>()),
  );
  sl.registerLazySingleton(
    () =>
        AuthenticateTelegramSessionUseCase(repository: sl<SessionRepository>()),
  );
  sl.registerLazySingleton(
    () => AuthenticateDevSessionUseCase(repository: sl<SessionRepository>()),
  );
  sl.registerLazySingleton(
    () => SaveAccessTokenUseCase(repository: sl<SessionRepository>()),
  );
  sl.registerLazySingleton(
    () => ClearSessionUseCase(repository: sl<SessionRepository>()),
  );
  sl.registerLazySingleton(
    () => SessionCubit(
      environment: sl<AppEnvironment>(),
      telegramWebAppBridge: sl<TelegramWebAppBridge>(),
      sessionRepository: sl<SessionRepository>(),
      getCurrentSessionUseCase: sl<GetCurrentSessionUseCase>(),
      authenticateTelegramSessionUseCase:
          sl<AuthenticateTelegramSessionUseCase>(),
      authenticateDevSessionUseCase: sl<AuthenticateDevSessionUseCase>(),
      saveAccessTokenUseCase: sl<SaveAccessTokenUseCase>(),
      clearSessionUseCase: sl<ClearSessionUseCase>(),
    ),
  );

  sl.registerLazySingleton<TodaySubmissionRepository>(
    () => TodaySubmissionRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton(
    () =>
        GetTodaySubmissionUseCase(repository: sl<TodaySubmissionRepository>()),
  );
  sl.registerLazySingleton(
    () => SaveDraftItemUseCase(repository: sl<TodaySubmissionRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteDraftItemUseCase(repository: sl<TodaySubmissionRepository>()),
  );
  sl.registerLazySingleton(
    () => ImportTodaySubmissionUseCase(
      repository: sl<TodaySubmissionRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => SubmitMorningUseCase(repository: sl<TodaySubmissionRepository>()),
  );
  sl.registerFactory(
    () => TodaySubmissionCubit(
      getTodaySubmissionUseCase: sl<GetTodaySubmissionUseCase>(),
      saveDraftItemUseCase: sl<SaveDraftItemUseCase>(),
      deleteDraftItemUseCase: sl<DeleteDraftItemUseCase>(),
      importTodaySubmissionUseCase: sl<ImportTodaySubmissionUseCase>(),
      submitMorningUseCase: sl<SubmitMorningUseCase>(),
    ),
  );

  sl.registerLazySingleton<PmUpdateRepository>(
    () => PmUpdateRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton(
    () => GetPmSummaryUseCase(repository: sl<PmUpdateRepository>()),
  );
  sl.registerLazySingleton(
    () => SavePmSummaryUseCase(repository: sl<PmUpdateRepository>()),
  );
  sl.registerFactory(
    () => PmUpdateCubit(
      getPmSummaryUseCase: sl<GetPmSummaryUseCase>(),
      savePmSummaryUseCase: sl<SavePmSummaryUseCase>(),
    ),
  );

  sl.registerLazySingleton<AdminConsoleRepository>(
    () => AdminConsoleRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerFactory(
    () => AdminConsoleCubit(repository: sl<AdminConsoleRepository>()),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin_console/presentation/cubit/admin_console_cubit.dart';
import '../../features/admin_console/presentation/cubit/admin_console_state.dart';
import '../../features/admin_console/presentation/screen/admin_console_screen.dart';
import '../../features/app_shell/presentation/screen/app_shell_screen.dart';
import '../../features/help/presentation/screen/help_screen.dart';
import '../../features/pm_update/presentation/cubit/pm_update_cubit.dart';
import '../../features/pm_update/presentation/screen/pm_update_screen.dart';
import '../../features/session/presentation/cubit/session_cubit.dart';
import '../../features/session/presentation/screen/session_gate_screen.dart';
import '../../features/today_submission/presentation/cubit/today_submission_cubit.dart';
import '../../features/today_submission/presentation/screen/today_submission_screen.dart';
import '../di/injection.dart';
import 'app_route_paths.dart';
import 'router_refresh_notifier.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter build({
    required SessionCubit sessionCubit,
    required RouterRefreshNotifier refreshNotifier,
  }) {
    return GoRouter(
      initialLocation: AppRoutePaths.root,
      refreshListenable: refreshNotifier,
      redirect: (context, state) {
        final location = state.uri.path;
        final sessionState = sessionCubit.state;
        if (!sessionState.isAuthenticated && location != AppRoutePaths.root) {
          return AppRoutePaths.root;
        }
        if (sessionState.isAuthenticated && location == AppRoutePaths.root) {
          return AppRoutePaths.today;
        }
        if (location.startsWith('/admin') &&
            !(sessionState.user?.isAdmin ?? false)) {
          return AppRoutePaths.today;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutePaths.root,
          builder: (context, state) => const SessionGateScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return AppShellScreen(
              currentLocation: state.uri.path,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: AppRoutePaths.today,
              builder: (context, state) {
                return BlocProvider<TodaySubmissionCubit>(
                  create: (context) => sl<TodaySubmissionCubit>(),
                  child: const TodaySubmissionScreen(),
                );
              },
            ),
            GoRoute(
              path: AppRoutePaths.pm,
              builder: (context, state) {
                return BlocProvider<PmUpdateCubit>(
                  create: (context) => sl<PmUpdateCubit>(),
                  child: const PmUpdateScreen(),
                );
              },
            ),
            GoRoute(
              path: AppRoutePaths.help,
              builder: (context, state) => const HelpScreen(),
            ),
            GoRoute(
              path: AppRoutePaths.adminOverview,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.overview);
              },
            ),
            GoRoute(
              path: AppRoutePaths.adminPending,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.pending);
              },
            ),
            GoRoute(
              path: AppRoutePaths.adminMetrics,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.metrics);
              },
            ),
            GoRoute(
              path: AppRoutePaths.adminUsers,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.users);
              },
            ),
            GoRoute(
              path: AppRoutePaths.adminReminders,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.reminders);
              },
            ),
            GoRoute(
              path: AppRoutePaths.adminWarnings,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.warnings);
              },
            ),
            GoRoute(
              path: AppRoutePaths.adminGroupBinding,
              builder: (context, state) {
                return buildAdminScreen(AdminSection.groupBinding);
              },
            ),
          ],
        ),
      ],
    );
  }
}

Widget buildAdminScreen(AdminSection section) {
  return BlocProvider<AdminConsoleCubit>(
    create: (context) => sl<AdminConsoleCubit>(),
    child: AdminConsoleScreen(section: section),
  );
}

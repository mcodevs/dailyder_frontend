import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/session/presentation/cubit/session_cubit.dart';
import '../di/injection.dart';
import '../localization/generated/app_localizations.dart';
import '../navigation/app_router.dart';
import '../navigation/router_refresh_notifier.dart';
import '../theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  late final SessionCubit sessionCubit;
  late final RouterRefreshNotifier refreshNotifier;
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    sessionCubit = sl<SessionCubit>();
    refreshNotifier = RouterRefreshNotifier(sessionCubit: sessionCubit);
    router = AppRouter.build(
      sessionCubit: sessionCubit,
      refreshNotifier: refreshNotifier,
    );
    sessionCubit.bootstrap();
  }

  @override
  void dispose() {
    refreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sessionCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.light(),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );
  }
}

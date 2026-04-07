import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widget/responsive_layout.dart';
import '../../../session/presentation/cubit/session_cubit.dart';
import '../widget/app_navigation_panel.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({
    required this.currentLocation,
    required this.child,
    super.key,
  });

  final String currentLocation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final user = sessionState.user;
    if (user == null) {
      return const SizedBox.shrink();
    }
    final pageTitle = resolveShellTitle(currentLocation);
    return ResponsiveLayout(
      mobile: (context) {
        return Scaffold(
          appBar: AppBar(title: Text(pageTitle)),
          drawer: Drawer(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: Builder(
              builder: (drawerContext) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                  child: AppNavigationPanel(
                    currentLocation: currentLocation,
                    user: user,
                    isCompact: true,
                    onLocationSelected: (location) {
                      Navigator.of(drawerContext).pop();
                      context.go(location);
                    },
                    onSignOutPressed: () {
                      Navigator.of(drawerContext).pop();
                      context.read<SessionCubit>().signOut();
                      context.go(AppRoutePaths.root);
                    },
                  ),
                );
              },
            ),
          ),
          body: Container(color: AppColors.mist, child: child),
        );
      },
      medium: (context) {
        return Scaffold(
          backgroundColor: AppColors.mist,
          body: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: AppNavigationPanel(
                  currentLocation: currentLocation,
                  user: user,
                  onLocationSelected: (location) {
                    context.go(location);
                  },
                  onSignOutPressed: () {
                    context.read<SessionCubit>().signOut();
                    context.go(AppRoutePaths.root);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      large: (context) {
        return Scaffold(
          backgroundColor: AppColors.mist,
          body: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
                child: AppNavigationPanel(
                  currentLocation: currentLocation,
                  user: user,
                  onLocationSelected: (location) {
                    context.go(location);
                  },
                  onSignOutPressed: () {
                    context.read<SessionCubit>().signOut();
                    context.go(AppRoutePaths.root);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String resolveShellTitle(String location) {
  switch (location) {
    case AppRoutePaths.today:
      return 'Bugungi tasklar';
    case AppRoutePaths.pm:
      return 'PM update';
    case AppRoutePaths.help:
      return 'Yordam';
    case AppRoutePaths.adminOverview:
      return 'Admin overview';
    case AppRoutePaths.adminPending:
      return 'Pending';
    case AppRoutePaths.adminMetrics:
      return 'Metrics';
    case AppRoutePaths.adminUsers:
      return 'Users';
    case AppRoutePaths.adminReminders:
      return 'Reminders';
    case AppRoutePaths.adminWarnings:
      return 'Warnings';
    case AppRoutePaths.adminGroupBinding:
      return 'Group binding';
    default:
      return 'Dailyder';
  }
}

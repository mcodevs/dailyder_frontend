import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_route_paths.dart';
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
    return ResponsiveLayout(
      mobile: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dailyder')),
          drawer: Drawer(
            child: AppNavigationPanel(
              currentLocation: currentLocation,
              user: user,
              onSignOutPressed: () {
                context.read<SessionCubit>().signOut();
                context.go(AppRoutePaths.root);
              },
            ),
          ),
          body: child,
        );
      },
      medium: (context) {
        return Scaffold(
          body: Row(
            children: [
              AppNavigationPanel(
                currentLocation: currentLocation,
                user: user,
                onSignOutPressed: () {
                  context.read<SessionCubit>().signOut();
                  context.go(AppRoutePaths.root);
                },
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
      large: (context) {
        return Scaffold(
          body: Row(
            children: [
              AppNavigationPanel(
                currentLocation: currentLocation,
                user: user,
                onSignOutPressed: () {
                  context.read<SessionCubit>().signOut();
                  context.go(AppRoutePaths.root);
                },
              ),
              Expanded(
                child: Container(color: const Color(0xFFF4F7FA), child: child),
              ),
            ],
          ),
        );
      },
    );
  }
}

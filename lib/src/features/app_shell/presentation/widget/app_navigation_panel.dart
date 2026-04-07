import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_route_paths.dart';
import '../../../session/domain/entity/session_user.dart';
import 'app_navigation_item.dart';

class AppNavigationPanel extends StatelessWidget {
  const AppNavigationPanel({
    required this.currentLocation,
    required this.user,
    required this.onSignOutPressed,
    super.key,
  });

  final String currentLocation;
  final SessionUser user;
  final VoidCallback onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    final items = buildNavigationItems();
    final visibleItems = items
        .where((item) => !item.adminOnly || user.isAdmin)
        .toList();
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFD8E1E8))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final item in visibleItems)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            IconData(item.icon, fontFamily: 'MaterialIcons'),
                          ),
                          title: Text(item.title),
                          selected: currentLocation == item.location,
                          onTap: () {
                            context.go(item.location);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSignOutPressed,
                  child: const Text('Chiqish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<AppNavigationItem> buildNavigationItems() {
  return const [
    AppNavigationItem(
      title: 'Bugungi tasklar',
      location: AppRoutePaths.today,
      icon: 0xe88a,
    ),
    AppNavigationItem(
      title: 'PM update',
      location: AppRoutePaths.pm,
      icon: 0xe192,
    ),
    AppNavigationItem(
      title: 'Yordam',
      location: AppRoutePaths.help,
      icon: 0xe887,
    ),
    AppNavigationItem(
      title: 'Admin overview',
      location: AppRoutePaths.adminOverview,
      icon: 0xe8ef,
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Pending',
      location: AppRoutePaths.adminPending,
      icon: 0xe8b5,
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Metrics',
      location: AppRoutePaths.adminMetrics,
      icon: 0xe24b,
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Users',
      location: AppRoutePaths.adminUsers,
      icon: 0xe7fd,
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Reminders',
      location: AppRoutePaths.adminReminders,
      icon: 0xe7f4,
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Warnings',
      location: AppRoutePaths.adminWarnings,
      icon: 0xe002,
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Group binding',
      location: AppRoutePaths.adminGroupBinding,
      icon: 0xe157,
      adminOnly: true,
    ),
  ];
}

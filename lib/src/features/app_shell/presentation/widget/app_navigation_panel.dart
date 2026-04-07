import 'package:flutter/material.dart';

import '../../../../core/navigation/app_route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../session/domain/entity/session_user.dart';
import 'app_navigation_item.dart';

class AppNavigationPanel extends StatelessWidget {
  const AppNavigationPanel({
    required this.currentLocation,
    required this.user,
    required this.onLocationSelected,
    required this.onSignOutPressed,
    super.key,
    this.isCompact = false,
  });

  final String currentLocation;
  final SessionUser user;
  final ValueChanged<String> onLocationSelected;
  final VoidCallback onSignOutPressed;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final items = buildNavigationItems()
        .where((item) => !item.adminOnly || user.isAdmin)
        .toList();
    final primaryItems = items.where((item) => !item.adminOnly).toList();
    final adminItems = items.where((item) => item.adminOnly).toList();
    return Container(
      width: isCompact ? double.infinity : 292,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNavigationProfileCard(user: user),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppNavigationSection(
                        title: 'Asosiy',
                        currentLocation: currentLocation,
                        items: primaryItems,
                        onLocationSelected: onLocationSelected,
                      ),
                      if (adminItems.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        AppNavigationSection(
                          title: 'Admin',
                          currentLocation: currentLocation,
                          items: adminItems,
                          onLocationSelected: onLocationSelected,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onSignOutPressed,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Chiqish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppNavigationProfileCard extends StatelessWidget {
  const AppNavigationProfileCard({required this.user, super.key});

  final SessionUser user;

  @override
  Widget build(BuildContext context) {
    final roleLabel = user.isAdmin ? 'Admin panel access' : 'Daily check-ins';
    final username = user.username?.isNotEmpty ?? false
        ? '@${user.username}'
        : 'Telegram user';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Dailyder',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            username,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: 6),
          Text(
            roleLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}

class AppNavigationSection extends StatelessWidget {
  const AppNavigationSection({
    required this.title,
    required this.currentLocation,
    required this.items,
    required this.onLocationSelected,
    super.key,
  });

  final String title;
  final String currentLocation;
  final List<AppNavigationItem> items;
  final ValueChanged<String> onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.inkMuted,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items) ...[
          AppNavigationTile(
            item: item,
            selected: currentLocation == item.location,
            onPressed: () => onLocationSelected(item.location),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class AppNavigationTile extends StatelessWidget {
  const AppNavigationTile({
    required this.item,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final AppNavigationItem item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? AppColors.ink : AppColors.inkMuted;
    final iconBackground = selected ? AppColors.accent : AppColors.surfaceSoft;
    final iconForeground = selected
        ? AppColors.accentForeground
        : AppColors.inkMuted;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? AppColors.accentSoft : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: iconForeground, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: selected ? AppColors.accent : AppColors.slate,
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
      icon: IconData(0xe88a, fontFamily: 'MaterialIcons'),
    ),
    AppNavigationItem(
      title: 'PM update',
      location: AppRoutePaths.pm,
      icon: IconData(0xe192, fontFamily: 'MaterialIcons'),
    ),
    AppNavigationItem(
      title: 'Yordam',
      location: AppRoutePaths.help,
      icon: IconData(0xe887, fontFamily: 'MaterialIcons'),
    ),
    AppNavigationItem(
      title: 'Admin overview',
      location: AppRoutePaths.adminOverview,
      icon: IconData(0xe8ef, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Pending',
      location: AppRoutePaths.adminPending,
      icon: IconData(0xe8b5, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Metrics',
      location: AppRoutePaths.adminMetrics,
      icon: IconData(0xe24b, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Users',
      location: AppRoutePaths.adminUsers,
      icon: IconData(0xe7fd, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Reminders',
      location: AppRoutePaths.adminReminders,
      icon: IconData(0xe7f4, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Warnings',
      location: AppRoutePaths.adminWarnings,
      icon: IconData(0xe002, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
    AppNavigationItem(
      title: 'Group binding',
      location: AppRoutePaths.adminGroupBinding,
      icon: IconData(0xe157, fontFamily: 'MaterialIcons'),
      adminOnly: true,
    ),
  ];
}

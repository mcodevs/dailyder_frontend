import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/admin_console_entities.dart';

class AdminPendingSection extends StatelessWidget {
  const AdminPendingSection({required this.snapshot, super.key});

  final PendingUsersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending - ${snapshot.workDate}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text('AM pending', style: Theme.of(context).textTheme.titleMedium),
          for (final user in snapshot.amPendingUsers) Text(user.displayName),
          const SizedBox(height: 16),
          Text('PM pending', style: Theme.of(context).textTheme.titleMedium),
          for (final user in snapshot.pmPendingUsers) Text(user.displayName),
        ],
      ),
    );
  }
}

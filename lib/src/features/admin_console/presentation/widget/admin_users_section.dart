import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/admin_console_entities.dart';

class AdminUsersSection extends StatelessWidget {
  const AdminUsersSection({required this.users, super.key});

  final List<AdminUserRecord> users;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Onboarded users',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          for (final user in users) ...[
            Text(
              '${user.displayName} ${user.username != null ? '(@${user.username})' : ''}',
            ),
            if (user.joinedAt != null) Text('Joined: ${user.joinedAt}'),
            const Divider(),
          ],
        ],
      ),
    );
  }
}

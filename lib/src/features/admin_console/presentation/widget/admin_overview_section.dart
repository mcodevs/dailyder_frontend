import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/admin_console_entities.dart';

class AdminOverviewSection extends StatelessWidget {
  const AdminOverviewSection({required this.overview, super.key});

  final AdminOverview overview;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admin overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('Adminlar: ${overview.adminCount}'),
          Text('Onboarded developerlar: ${overview.onboardedUserCount}'),
          Text('AM scheduler: ${overview.amScheduler}'),
          Text('PM scheduler: ${overview.pmScheduler}'),
          Text('Group: ${overview.groupTitle ?? 'Biriktirilmagan'}'),
          Text(
            'Topic: ${overview.messageThreadId?.toString() ?? 'Butun guruh'}',
          ),
        ],
      ),
    );
  }
}

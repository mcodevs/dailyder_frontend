import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/admin_console_entities.dart';

class AdminMetricsSection extends StatelessWidget {
  const AdminMetricsSection({required this.snapshot, super.key});

  final MetricsReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metrics ${snapshot.startDate} - ${snapshot.endDate}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          for (final user in snapshot.users) ...[
            Text(
              user.user.displayName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('AM: ${user.amSubmitted}/${user.expectedWorkdays}'),
            Text('PM: ${user.pmSubmitted}, missed: ${user.missedPm}'),
            Text(
              '✅ ${user.completed}  ⚠️ ${user.warning}  🚫 ${user.blocked}  🪓 ${user.dropped}',
            ),
            const Divider(),
          ],
        ],
      ),
    );
  }
}

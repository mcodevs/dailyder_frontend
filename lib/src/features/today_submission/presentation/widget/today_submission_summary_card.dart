import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/today_submission_snapshot.dart';

class TodaySubmissionSummaryCard extends StatelessWidget {
  const TodaySubmissionSummaryCard({required this.snapshot, super.key});

  final TodaySubmissionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final submission = snapshot.submission;
    final statusLabel = submission == null
        ? 'Draft hali boshlanmagan'
        : submission.pmSubmittedAt != null
        ? 'PM update yuborilgan'
        : submission.amSubmittedAt != null
        ? 'AM yuborilgan'
        : 'Draft holatida';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bugungi tasklar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Sana: ${snapshot.workDate}'),
          Text('Holat: $statusLabel'),
          Text('Tasklar soni: ${submission?.items.length ?? 0}'),
        ],
      ),
    );
  }
}

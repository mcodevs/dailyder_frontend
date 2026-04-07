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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bugungi tasklar',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Bugungi draftni poll option uslubida yig‘ing va yuboring.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              TodaySummaryMetricPill(
                label: 'Status',
                value: statusLabel,
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              TodaySummaryMetricPill(
                label: 'Sana',
                value: snapshot.workDate,
                icon: Icons.calendar_month_outlined,
              ),
              TodaySummaryMetricPill(
                label: 'Tasklar',
                value: '${submission?.items.length ?? 0}',
                icon: Icons.format_list_bulleted_rounded,
              ),
              TodaySummaryMetricPill(
                label: 'Holat',
                value: submission == null ? 'Draft yo‘q' : 'Draft bor',
                icon: Icons.layers_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TodaySummaryMetricPill extends StatelessWidget {
  const TodaySummaryMetricPill({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101722),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3748)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

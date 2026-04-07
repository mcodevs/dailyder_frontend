import 'package:flutter/material.dart';

import '../cubit/pm_update_state.dart';
import '../../domain/entity/pm_summary.dart';
import 'pm_update_theme.dart';

class PmUpdateSummaryCard extends StatelessWidget {
  const PmUpdateSummaryCard({
    required this.summary,
    required this.state,
    super.key,
  });

  final PmSummary summary;
  final PmUpdateState state;

  @override
  Widget build(BuildContext context) {
    final submission = summary.submission;
    final items = submission?.items ?? const [];
    final totalSubtasks = items.fold<int>(
      0,
      (total, item) => total + item.subtasks.length,
    );
    final selectedStatuses =
        state.itemStatuses.length +
        state.subtaskStatuses.values.where((value) => value != null).length;
    final totalStatuses = items.length + totalSubtasks;
    final progress = totalStatuses == 0
        ? 0.0
        : selectedStatuses / totalStatuses;

    return Container(
      decoration: PmUpdateTheme.panelDecoration(elevated: true),
      child: Padding(
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
                        'PM update',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: PmUpdateTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bugungi AM draftni tez ko‘rib chiqib, statuslarni belgilang.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PmUpdateTheme.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                PmSummaryPill(
                  icon: Icons.insights_outlined,
                  label: '${(progress * 100).round()}%',
                  color: PmUpdateTheme.accent,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PmSummaryMetaChip(
                  icon: Icons.calendar_today_outlined,
                  label: summary.workDate,
                ),
                PmSummaryMetaChip(
                  icon: Icons.list_alt_outlined,
                  label: '${items.length} task',
                ),
                PmSummaryMetaChip(
                  icon: Icons.alt_route_outlined,
                  label: '$totalSubtasks subtask',
                ),
                PmSummaryMetaChip(
                  icon: Icons.checklist_outlined,
                  label: '$selectedStatuses/$totalStatuses belgilangan',
                ),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress.clamp(0.0, 1.0),
                backgroundColor: PmUpdateTheme.surfaceSoft,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  PmUpdateTheme.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PmSummaryPill extends StatelessWidget {
  const PmSummaryPill({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Color.lerp(color, PmUpdateTheme.surface, 0.84),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: PmUpdateTheme.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class PmSummaryMetaChip extends StatelessWidget {
  const PmSummaryMetaChip({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: PmUpdateTheme.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PmUpdateTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: PmUpdateTheme.textSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PmUpdateTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

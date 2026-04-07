import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/submission_record.dart';
import 'today_submission_task_card.dart';

class TodaySubmissionListPanel extends StatelessWidget {
  const TodaySubmissionListPanel({
    required this.items,
    required this.selectedItemId,
    required this.onCreatePressed,
    required this.onImportPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onSubmitPressed,
    required this.isBusy,
    super.key,
  });

  final List<SubmissionItemRecord> items;
  final String? selectedItemId;
  final VoidCallback onCreatePressed;
  final VoidCallback onImportPressed;
  final void Function(String itemId) onEditPressed;
  final void Function(String itemId) onDeletePressed;
  final VoidCallback onSubmitPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
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
                      'Draft tasklar',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${items.length} ta item, tanlanganini tahrirlash mumkin.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.45),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  isBusy ? 'Yuklanmoqda...' : 'Tayyor',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: isBusy ? null : onCreatePressed,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Task qo‘shish'),
              ),
              OutlinedButton.icon(
                onPressed: isBusy ? null : onImportPressed,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Matndan import'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (final item in items) ...[
            TodaySubmissionTaskCard(
              item: item,
              selected: selectedItemId == item.id,
              isBusy: isBusy,
              onEditPressed: () => onEditPressed(item.id),
              onDeletePressed: () => onDeletePressed(item.id),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isBusy || items.isEmpty ? null : onSubmitPressed,
              icon: const Icon(Icons.send_rounded),
              label: const Text('AM yuborish'),
            ),
          ),
        ],
      ),
    );
  }
}

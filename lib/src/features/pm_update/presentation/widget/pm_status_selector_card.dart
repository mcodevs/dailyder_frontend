import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../../today_submission/domain/entity/submission_record.dart';

class PmStatusSelectorCard extends StatelessWidget {
  const PmStatusSelectorCard({
    required this.item,
    required this.itemStatus,
    required this.subtaskStatuses,
    required this.onItemStatusChanged,
    required this.onSubtaskStatusChanged,
    super.key,
  });

  final SubmissionItemRecord item;
  final String? itemStatus;
  final Map<String, String?> subtaskStatuses;
  final void Function(String? value) onItemStatusChanged;
  final void Function(String? value, SubmissionSubtaskRecord subtask)
  onSubtaskStatusChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.projectName} - ${item.taskName}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: itemStatus?.isEmpty ?? true ? null : itemStatus,
            items: buildStatusMenuItems(),
            onChanged: onItemStatusChanged,
            decoration: const InputDecoration(labelText: 'Task status'),
          ),
          const SizedBox(height: 16),
          for (final subtask in item.subtasks) ...[
            DropdownButtonFormField<String?>(
              initialValue: subtaskStatuses[subtask.id],
              items: buildStatusMenuItems(includeEmpty: true),
              onChanged: (value) => onSubtaskStatusChanged(value, subtask),
              decoration: InputDecoration(labelText: subtask.name),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

List<DropdownMenuItem<String?>> buildStatusMenuItems({
  bool includeEmpty = false,
}) {
  final items = <DropdownMenuItem<String?>>[];
  if (includeEmpty) {
    items.add(const DropdownMenuItem(value: null, child: Text('Tanlanmagan')));
  }
  items.addAll(const [
    DropdownMenuItem(value: 'completed', child: Text('✅ Bajarildi')),
    DropdownMenuItem(value: 'warning', child: Text('⚠️ Xavf bor')),
    DropdownMenuItem(value: 'blocked', child: Text('🚫 To‘siq bor')),
    DropdownMenuItem(value: 'dropped', child: Text('🪓 Bekor qilindi')),
  ]);
  return items;
}

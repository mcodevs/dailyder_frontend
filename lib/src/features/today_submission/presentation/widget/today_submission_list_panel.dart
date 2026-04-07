import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/submission_record.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: isBusy ? null : onCreatePressed,
                child: const Text('Task qo‘shish'),
              ),
              OutlinedButton(
                onPressed: isBusy ? null : onImportPressed,
                child: const Text('Matndan import'),
              ),
              FilledButton.tonal(
                onPressed: isBusy || items.isEmpty ? null : onSubmitPressed,
                child: const Text('AM yuborish'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (final item in items) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              selected: selectedItemId == item.id,
              title: Text('${item.projectName} - ${item.taskName}'),
              subtitle: Text(item.subtaskNames.join(', ')),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    onPressed: isBusy ? null : () => onEditPressed(item.id),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: isBusy ? null : () => onDeletePressed(item.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ],
      ),
    );
  }
}

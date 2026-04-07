import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/submission_record.dart';

class DraftItemEditorPanel extends StatefulWidget {
  const DraftItemEditorPanel({
    required this.modeLabel,
    required this.isSaving,
    required this.onCancelPressed,
    required this.onSavePressed,
    super.key,
    this.initialItem,
  });

  final String modeLabel;
  final SubmissionItemRecord? initialItem;
  final bool isSaving;
  final VoidCallback onCancelPressed;
  final void Function({
    required String projectName,
    required String taskName,
    required List<String> subtaskNames,
  })
  onSavePressed;

  @override
  State<DraftItemEditorPanel> createState() => DraftItemEditorPanelState();
}

class DraftItemEditorPanelState extends State<DraftItemEditorPanel> {
  late final TextEditingController projectNameController;
  late final TextEditingController taskNameController;
  late final TextEditingController subtasksController;

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController(
      text: widget.initialItem?.projectName ?? '',
    );
    taskNameController = TextEditingController(
      text: widget.initialItem?.taskName ?? '',
    );
    subtasksController = TextEditingController(
      text: (widget.initialItem?.subtaskNames ?? const <String>[]).join('\n'),
    );
  }

  @override
  void dispose() {
    projectNameController.dispose();
    taskNameController.dispose();
    subtasksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.modeLabel, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: projectNameController,
            decoration: const InputDecoration(labelText: 'Project'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: taskNameController,
            decoration: const InputDecoration(labelText: 'Task'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: subtasksController,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Subtasklar',
              hintText: 'Har bir subtaskni yangi qatordan yozing',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: widget.isSaving
                    ? null
                    : () {
                        widget.onSavePressed(
                          projectName: projectNameController.text,
                          taskName: taskNameController.text,
                          subtaskNames: subtasksController.text
                              .split('\n')
                              .map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .toList(),
                        );
                      },
                child: Text(widget.isSaving ? 'Saqlanmoqda...' : 'Saqlash'),
              ),
              OutlinedButton(
                onPressed: widget.isSaving ? null : widget.onCancelPressed,
                child: const Text('Bekor qilish'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

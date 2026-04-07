import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/submission_record.dart';
import 'today_subtask_editor_list.dart';

class DraftItemEditorPanel extends StatefulWidget {
  const DraftItemEditorPanel({
    required this.modeLabel,
    required this.modeHint,
    required this.isSaving,
    required this.onCancelPressed,
    required this.onSavePressed,
    super.key,
    this.initialItem,
  });

  final String modeLabel;
  final String modeHint;
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
  late final List<TextEditingController> subtaskControllers;

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController(
      text: widget.initialItem?.projectName ?? '',
    );
    taskNameController = TextEditingController(
      text: widget.initialItem?.taskName ?? '',
    );
    final initialSubtasks =
        widget.initialItem?.subtaskNames ?? const <String>[];
    subtaskControllers = initialSubtasks.isEmpty
        ? [TextEditingController()]
        : initialSubtasks
              .map((text) => TextEditingController(text: text))
              .toList();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    taskNameController.dispose();
    for (final controller in subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addSubtaskRow() {
    if (widget.isSaving) {
      return;
    }
    setState(() {
      subtaskControllers.add(TextEditingController());
    });
  }

  void removeSubtaskRow(int index) {
    if (widget.isSaving) {
      return;
    }
    if (subtaskControllers.length == 1) {
      setState(() {
        subtaskControllers.first.clear();
      });
      return;
    }
    setState(() {
      subtaskControllers.removeAt(index).dispose();
    });
  }

  void saveDraft() {
    widget.onSavePressed(
      projectName: projectNameController.text,
      taskName: taskNameController.text,
      subtaskNames: subtaskControllers
          .map((controller) => controller.text.trim())
          .where((value) => value.isNotEmpty)
          .toList(),
    );
  }

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
                      widget.modeLabel,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.modeHint,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  widget.initialItem == null ? 'Composer' : 'Draft',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: projectNameController,
            enabled: !widget.isSaving,
            decoration: const InputDecoration(
              labelText: 'Project',
              hintText: 'Project nomi',
              prefixIcon: Icon(Icons.folder_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: taskNameController,
            enabled: !widget.isSaving,
            decoration: const InputDecoration(
              labelText: 'Task',
              hintText: 'Task nomi',
              prefixIcon: Icon(Icons.task_alt_outlined),
            ),
          ),
          const SizedBox(height: 18),
          TodaySubtaskEditorList(
            controllers: subtaskControllers,
            isSaving: widget.isSaving,
            onAddPressed: addSubtaskRow,
            onRemovePressed: removeSubtaskRow,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.isSaving ? null : saveDraft,
              icon: widget.isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(widget.isSaving ? 'Saqlanmoqda...' : 'Saqlash'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.isSaving ? null : widget.onCancelPressed,
              icon: const Icon(Icons.close_rounded),
              label: const Text('Bekor qilish'),
            ),
          ),
        ],
      ),
    );
  }
}

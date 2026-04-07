import 'package:flutter/material.dart';

class TodaySubtaskEditorList extends StatelessWidget {
  const TodaySubtaskEditorList({
    required this.controllers,
    required this.isSaving,
    required this.onAddPressed,
    required this.onRemovePressed,
    super.key,
  });

  final List<TextEditingController> controllers;
  final bool isSaving;
  final VoidCallback onAddPressed;
  final void Function(int index) onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Subtasklar',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton.icon(
              onPressed: isSaving ? null : onAddPressed,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Subtask qo‘shish'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Har bir qator poll option kabi ishlaydi.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < controllers.length; index++) ...[
          TodaySubtaskEditorRow(
            controller: controllers[index],
            hintText: 'Subtask ${index + 1}',
            isSaving: isSaving,
            canRemove: controllers.length > 1,
            onRemovePressed: () => onRemovePressed(index),
          ),
          if (index != controllers.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class TodaySubtaskEditorRow extends StatelessWidget {
  const TodaySubtaskEditorRow({
    required this.controller,
    required this.hintText,
    required this.isSaving,
    required this.canRemove,
    required this.onRemovePressed,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isSaving;
  final bool canRemove;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: !isSaving,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.drag_indicator_rounded),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: isSaving || !canRemove ? null : onRemovePressed,
          icon: const Icon(Icons.remove_circle_outline_rounded),
          tooltip: 'Subtaskni olib tashlash',
        ),
      ],
    );
  }
}

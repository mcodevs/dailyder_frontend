import 'package:flutter/material.dart';

import '../../domain/entity/submission_record.dart';

class TodaySubmissionTaskCard extends StatelessWidget {
  const TodaySubmissionTaskCard({
    required this.item,
    required this.selected,
    required this.isBusy,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final SubmissionItemRecord item;
  final bool selected;
  final bool isBusy;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;
    final backgroundColor = selected
        ? const Color(0xFF1A2231)
        : Theme.of(context).cardTheme.color ?? const Color(0xFF151C27);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TodayTaskTag(
                            label: item.projectName,
                            icon: Icons.folder_outlined,
                          ),
                          if (selected)
                            TodayTaskTag(
                              label: 'Tanlangan',
                              icon: Icons.radio_button_checked_rounded,
                              accent: true,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.taskName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    TodayCardActionButton(
                      tooltip: 'Tahrirlash',
                      icon: Icons.edit_outlined,
                      onPressed: isBusy ? null : onEditPressed,
                    ),
                    const SizedBox(height: 8),
                    TodayCardActionButton(
                      tooltip: 'O‘chirish',
                      icon: Icons.delete_outline_rounded,
                      onPressed: isBusy ? null : onDeletePressed,
                      danger: true,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Subtasklar',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            if (item.subtaskNames.isEmpty)
              Text(
                'Subtask yo‘q',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final subtask in item.subtaskNames)
                    TodaySubtaskChip(label: subtask),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TodayTaskTag extends StatelessWidget {
  const TodayTaskTag({
    required this.label,
    required this.icon,
    super.key,
    this.accent = false,
  });

  final String label;
  final IconData icon;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final background = accent
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)
        : const Color(0xFF101722);
    final foreground = accent
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFFF2F6FB);
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: accent
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.45)
              : const Color(0xFF2A3748),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TodaySubtaskChip extends StatelessWidget {
  const TodaySubtaskChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101722),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF2A3748)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: const Color(0xFFF2F6FB)),
      ),
    );
  }
}

class TodayCardActionButton extends StatelessWidget {
  const TodayCardActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    super.key,
    this.danger = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final foreground = danger
        ? Theme.of(context).colorScheme.error
        : const Color(0xFFF2F6FB);
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF101722),
        foregroundColor: foreground,
        side: const BorderSide(color: Color(0xFF2A3748)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../today_submission/domain/entity/submission_record.dart';
import 'pm_update_theme.dart';

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
    final currentOption = pmStatusOptionForValue(itemStatus);
    return Container(
      decoration: PmUpdateTheme.panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                        item.projectName,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: PmUpdateTheme.accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.taskName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: PmUpdateTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.subtasks.length} subtask',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PmUpdateTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                PmStatusBadge(option: currentOption),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Task holati',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: PmUpdateTheme.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.15,
              ),
            ),
            const SizedBox(height: 10),
            PmStatusChoiceRow(
              key: ValueKey('item-status-${item.id}'),
              selectedValue: itemStatus,
              onSelected: onItemStatusChanged,
            ),
            if (item.subtasks.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Subtasklar',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: PmUpdateTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(height: 12),
              for (final subtask in item.subtasks) ...[
                PmSubtaskStatusCard(
                  key: ValueKey('subtask-card-${subtask.id}'),
                  subtask: subtask,
                  selectedValue: subtaskStatuses[subtask.id],
                  onChanged: (value) => onSubtaskStatusChanged(value, subtask),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class PmSubtaskStatusCard extends StatelessWidget {
  const PmSubtaskStatusCard({
    required this.subtask,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final SubmissionSubtaskRecord subtask;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentOption = pmStatusOptionForValue(selectedValue);
    return Container(
      decoration: PmUpdateTheme.statusDecoration(
        color: currentOption.color,
        selected: selectedValue != null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    subtask.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: PmUpdateTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PmStatusBadge(option: currentOption, compact: true),
              ],
            ),
            const SizedBox(height: 12),
            PmStatusChoiceRow(
              key: ValueKey('subtask-status-${subtask.id}'),
              selectedValue: selectedValue,
              onSelected: onChanged,
              compact: true,
            ),
          ],
        ),
      ),
    );
  }
}

class PmStatusChoiceRow extends StatelessWidget {
  const PmStatusChoiceRow({
    required this.selectedValue,
    required this.onSelected,
    super.key,
    this.compact = false,
  });

  final String? selectedValue;
  final ValueChanged<String?> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in PmUpdateTheme.statusOptions)
          PmStatusChoiceButton(
            key: ValueKey(
              'choice-${option.value ?? 'none'}-${compact ? 'c' : 'd'}',
            ),
            option: option,
            selected: option.value == selectedValue,
            compact: compact,
            onPressed: () => onSelected(option.value),
          ),
      ],
    );
  }
}

class PmStatusChoiceButton extends StatelessWidget {
  const PmStatusChoiceButton({
    required this.option,
    required this.selected,
    required this.onPressed,
    super.key,
    this.compact = false,
  });

  final PmStatusOption option;
  final bool selected;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final verticalPadding = compact ? 9.0 : 11.0;
    final horizontalPadding = compact ? 12.0 : 14.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: PmUpdateTheme.statusDecoration(
            color: option.color,
            selected: selected,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option.icon,
                size: compact ? 16 : 17,
                color: selected ? option.color : PmUpdateTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                option.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected
                      ? PmUpdateTheme.textPrimary
                      : PmUpdateTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PmStatusBadge extends StatelessWidget {
  const PmStatusBadge({required this.option, super.key, this.compact = false});

  final PmStatusOption option;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: Color.lerp(option.color, PmUpdateTheme.surface, 0.78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: option.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(option.icon, size: compact ? 15 : 16, color: option.color),
          const SizedBox(width: 6),
          Text(
            option.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: PmUpdateTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';

class AdminRemindersSection extends StatelessWidget {
  const AdminRemindersSection({
    required this.onReminderPressed,
    required this.isBusy,
    super.key,
  });

  final void Function(String period) onReminderPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: isBusy ? null : () => onReminderPressed('am'),
                child: const Text('AM reminder'),
              ),
              FilledButton.tonal(
                onPressed: isBusy ? null : () => onReminderPressed('pm'),
                child: const Text('PM reminder'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';

class TodayEmptyState extends StatelessWidget {
  const TodayEmptyState({
    required this.onCreatePressed,
    required this.onImportPressed,
    super.key,
  });

  final VoidCallback onCreatePressed;
  final VoidCallback onImportPressed;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hozircha task yo‘q',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Yangi task qo‘shing yoki matndan import qiling.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: onCreatePressed,
                child: const Text('Task qo‘shish'),
              ),
              OutlinedButton(
                onPressed: onImportPressed,
                child: const Text('Matndan import'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.playlist_add_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Hozircha task yo‘q',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Yangi draftni qo‘shing yoki matndan import qiling. Har bir subtask poll option kabi alohida bo‘ladi.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: onCreatePressed,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Task qo‘shish'),
              ),
              OutlinedButton.icon(
                onPressed: onImportPressed,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Matndan import'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';

class PmFinalNoteCard extends StatelessWidget {
  const PmFinalNoteCard({
    required this.controller,
    required this.onSavePressed,
    required this.isSaving,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSavePressed;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yakuniy izoh', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Bugungi ish bo‘yicha qo‘shimcha izoh',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: isSaving ? null : onSavePressed,
            child: Text(isSaving ? 'Saqlanmoqda...' : 'PM update saqlash'),
          ),
        ],
      ),
    );
  }
}

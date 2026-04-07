import 'package:flutter/material.dart';

import 'pm_update_theme.dart';

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
    return Container(
      decoration: PmUpdateTheme.panelDecoration(elevated: true),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: PmUpdateTheme.accentSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: PmUpdateTheme.accent),
                  ),
                  child: const Icon(
                    Icons.edit_note_outlined,
                    color: PmUpdateTheme.accent,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yakuniy izoh',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: PmUpdateTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Qisqa xulosa qoldiring. Saqlash tugmasi barcha statuslarni backendga yuboradi.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PmUpdateTheme.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              key: const ValueKey('pm-final-note-field'),
              controller: controller,
              minLines: 4,
              maxLines: 6,
              cursorColor: PmUpdateTheme.accent,
              style: const TextStyle(
                color: PmUpdateTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: PmUpdateTheme.fieldDecoration(
                labelText: 'Final note',
                hintText: 'Bugungi ish bo‘yicha qo‘shimcha izoh',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('pm-final-save'),
                onPressed: isSaving ? null : onSavePressed,
                style: PmUpdateTheme.primaryButtonStyle(),
                child: Text(isSaving ? 'Saqlanmoqda...' : 'PM update saqlash'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

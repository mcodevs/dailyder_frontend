import 'package:flutter/material.dart';

import '../cubit/today_submission_state.dart';
import 'today_submission_feedback_card.dart';
import 'draft_item_editor_panel.dart';
import 'import_submission_panel.dart';

class TodaySubmissionEditorPanel extends StatelessWidget {
  const TodaySubmissionEditorPanel({
    required this.state,
    required this.onCancelEditorPressed,
    required this.onSaveDraftPressed,
    required this.onImportDraftPressed,
    super.key,
  });

  final TodaySubmissionState state;
  final VoidCallback onCancelEditorPressed;
  final void Function({
    String? itemId,
    required String projectName,
    required String taskName,
    required List<String> subtaskNames,
  })
  onSaveDraftPressed;
  final void Function(String rawText) onImportDraftPressed;

  @override
  Widget build(BuildContext context) {
    if (state.editorMode == TodayEditorMode.importText) {
      return ImportSubmissionPanel(
        isSaving: state.isSaving,
        onCancelPressed: onCancelEditorPressed,
        onImportPressed: onImportDraftPressed,
      );
    }

    if (state.editorMode == TodayEditorMode.create) {
      return DraftItemEditorPanel(
        modeLabel: 'Yangi task',
        modeHint: 'Poll option kabi har bir subtaskni alohida qatorga yozing.',
        initialItem: null,
        isSaving: state.isSaving,
        onCancelPressed: onCancelEditorPressed,
        onSavePressed:
            ({
              required String projectName,
              required String taskName,
              required List<String> subtaskNames,
            }) {
              onSaveDraftPressed(
                itemId: null,
                projectName: projectName,
                taskName: taskName,
                subtaskNames: subtaskNames,
              );
            },
      );
    }

    if (state.editorMode == TodayEditorMode.edit) {
      final item = state.selectedItem;
      if (item == null) {
        return const SizedBox.shrink();
      }
      return DraftItemEditorPanel(
        modeLabel: 'Taskni tahrirlash',
        modeHint: 'Kichik o‘zgarishlar tez, tartibli va ko‘rinadigan bo‘lsin.',
        initialItem: item,
        isSaving: state.isSaving,
        onCancelPressed: onCancelEditorPressed,
        onSavePressed:
            ({
              required String projectName,
              required String taskName,
              required List<String> subtaskNames,
            }) {
              onSaveDraftPressed(
                itemId: item.id,
                projectName: projectName,
                taskName: taskName,
                subtaskNames: subtaskNames,
              );
            },
      );
    }

    return const TodayStatusView(
      title: 'Composer tayyor',
      message:
          'Task qo‘shish yoki matndan import qiling. Poll option uslubidagi composer shu yerda ochiladi.',
    );
  }
}

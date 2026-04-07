import 'package:flutter/material.dart';

import '../../../../core/widget/responsive_layout.dart';
import '../../domain/entity/submission_record.dart';
import '../../domain/entity/today_submission_snapshot.dart';
import '../cubit/today_submission_state.dart';
import 'draft_item_editor_panel.dart';
import 'import_submission_panel.dart';
import 'today_empty_state.dart';
import 'today_submission_list_panel.dart';
import 'today_submission_summary_card.dart';

class TodaySubmissionBoard extends StatelessWidget {
  const TodaySubmissionBoard({
    required this.state,
    required this.onCreatePressed,
    required this.onImportPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onSubmitPressed,
    required this.onCancelEditorPressed,
    required this.onSaveDraftPressed,
    required this.onImportDraftPressed,
    super.key,
  });

  final TodaySubmissionState state;
  final VoidCallback onCreatePressed;
  final VoidCallback onImportPressed;
  final void Function(String itemId) onEditPressed;
  final void Function(String itemId) onDeletePressed;
  final VoidCallback onSubmitPressed;
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
    final snapshot =
        state.snapshot ??
        const TodaySubmissionSnapshot(workDate: '', submission: null);
    final content = buildEditorForState(state);
    return ResponsiveLayout(
      mobile: (context) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TodaySubmissionSummaryCard(snapshot: snapshot),
            const SizedBox(height: 16),
            buildPrimaryPanel(snapshot),
            if (content != null) ...[
              const SizedBox(height: 16),
              buildEditorWidget(content),
            ],
          ],
        );
      },
      medium: (context) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TodaySubmissionSummaryCard(snapshot: snapshot),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: buildPrimaryPanel(snapshot)),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: buildEditorWidget(content)),
              ],
            ),
          ],
        );
      },
      large: (context) {
        return ListView(
          padding: const EdgeInsets.all(28),
          children: [
            TodaySubmissionSummaryCard(snapshot: snapshot),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: buildPrimaryPanel(snapshot)),
                const SizedBox(width: 24),
                Expanded(flex: 5, child: buildEditorWidget(content)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildPrimaryPanel(TodaySubmissionSnapshot snapshot) {
    final items = snapshot.submission?.items ?? const <SubmissionItemRecord>[];
    if (items.isEmpty) {
      return TodayEmptyState(
        onCreatePressed: onCreatePressed,
        onImportPressed: onImportPressed,
      );
    }
    return TodaySubmissionListPanel(
      items: items,
      selectedItemId: state.selectedItemId,
      onCreatePressed: onCreatePressed,
      onImportPressed: onImportPressed,
      onEditPressed: onEditPressed,
      onDeletePressed: onDeletePressed,
      onSubmitPressed: onSubmitPressed,
      isBusy: state.isSaving,
    );
  }

  Object? buildEditorForState(TodaySubmissionState currentState) {
    if (currentState.editorMode == TodayEditorMode.importText) {
      return 'import';
    }
    if (currentState.editorMode == TodayEditorMode.create) {
      return const SubmissionItemRecord(
        id: '',
        projectName: '',
        taskName: '',
        sortOrder: 0,
        subtasks: <SubmissionSubtaskRecord>[],
        subtaskNames: <String>[],
      );
    }
    if (currentState.editorMode == TodayEditorMode.edit) {
      return currentState.selectedItem;
    }
    return null;
  }

  Widget buildEditorWidget(Object? content) {
    if (content == null) {
      return const SizedBox.shrink();
    }
    if (content is String && content == 'import') {
      return ImportSubmissionPanel(
        isSaving: state.isSaving,
        onCancelPressed: onCancelEditorPressed,
        onImportPressed: onImportDraftPressed,
      );
    }
    final item = content as SubmissionItemRecord;
    return DraftItemEditorPanel(
      modeLabel: state.editorMode == TodayEditorMode.edit
          ? 'Taskni tahrirlash'
          : 'Yangi task',
      initialItem: item.id.isEmpty ? null : item,
      isSaving: state.isSaving,
      onCancelPressed: onCancelEditorPressed,
      onSavePressed:
          ({
            required String projectName,
            required String taskName,
            required List<String> subtaskNames,
          }) {
            onSaveDraftPressed(
              itemId: state.editorMode == TodayEditorMode.edit ? item.id : null,
              projectName: projectName,
              taskName: taskName,
              subtaskNames: subtaskNames,
            );
          },
    );
  }
}

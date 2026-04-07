import 'package:flutter/material.dart';

import '../../../../core/widget/responsive_layout.dart';
import '../../domain/entity/today_submission_snapshot.dart';
import '../cubit/today_submission_state.dart';
import 'today_submission_editor_panel.dart';
import 'today_submission_primary_panel.dart';
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
    return ResponsiveLayout(
      mobile: (context) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TodaySubmissionSummaryCard(snapshot: snapshot),
                  const SizedBox(height: 16),
                  TodaySubmissionPrimaryPanel(
                    snapshot: snapshot,
                    state: state,
                    onCreatePressed: onCreatePressed,
                    onImportPressed: onImportPressed,
                    onEditPressed: onEditPressed,
                    onDeletePressed: onDeletePressed,
                    onSubmitPressed: onSubmitPressed,
                  ),
                  if (state.editorMode != TodayEditorMode.overview) ...[
                    const SizedBox(height: 16),
                    TodaySubmissionEditorPanel(
                      state: state,
                      onCancelEditorPressed: onCancelEditorPressed,
                      onSaveDraftPressed: onSaveDraftPressed,
                      onImportDraftPressed: onImportDraftPressed,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
      medium: (context) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TodaySubmissionSummaryCard(snapshot: snapshot),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: TodaySubmissionPrimaryPanel(
                            snapshot: snapshot,
                            state: state,
                            onCreatePressed: onCreatePressed,
                            onImportPressed: onImportPressed,
                            onEditPressed: onEditPressed,
                            onDeletePressed: onDeletePressed,
                            onSubmitPressed: onSubmitPressed,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 5,
                          child: TodaySubmissionEditorPanel(
                            state: state,
                            onCancelEditorPressed: onCancelEditorPressed,
                            onSaveDraftPressed: onSaveDraftPressed,
                            onImportDraftPressed: onImportDraftPressed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      large: (context) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TodaySubmissionSummaryCard(snapshot: snapshot),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: TodaySubmissionPrimaryPanel(
                            snapshot: snapshot,
                            state: state,
                            onCreatePressed: onCreatePressed,
                            onImportPressed: onImportPressed,
                            onEditPressed: onEditPressed,
                            onDeletePressed: onDeletePressed,
                            onSubmitPressed: onSubmitPressed,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 5,
                          child: TodaySubmissionEditorPanel(
                            state: state,
                            onCancelEditorPressed: onCancelEditorPressed,
                            onSaveDraftPressed: onSaveDraftPressed,
                            onImportDraftPressed: onImportDraftPressed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

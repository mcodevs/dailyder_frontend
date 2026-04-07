import 'package:flutter/material.dart';

import '../../domain/entity/submission_record.dart';
import '../../domain/entity/today_submission_snapshot.dart';
import '../cubit/today_submission_state.dart';
import 'today_empty_state.dart';
import 'today_submission_list_panel.dart';

class TodaySubmissionPrimaryPanel extends StatelessWidget {
  const TodaySubmissionPrimaryPanel({
    required this.snapshot,
    required this.state,
    required this.onCreatePressed,
    required this.onImportPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onSubmitPressed,
    super.key,
  });

  final TodaySubmissionSnapshot snapshot;
  final TodaySubmissionState state;
  final VoidCallback onCreatePressed;
  final VoidCallback onImportPressed;
  final void Function(String itemId) onEditPressed;
  final void Function(String itemId) onDeletePressed;
  final VoidCallback onSubmitPressed;

  @override
  Widget build(BuildContext context) {
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
}

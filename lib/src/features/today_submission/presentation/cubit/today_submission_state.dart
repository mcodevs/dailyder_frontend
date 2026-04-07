import 'package:equatable/equatable.dart';

import '../../../../common/data/enums/status.dart';
import '../../domain/entity/submission_record.dart';
import '../../domain/entity/today_submission_snapshot.dart';

enum TodayEditorMode { overview, create, edit, importText }

class TodaySubmissionState extends Equatable {
  const TodaySubmissionState({
    required this.status,
    required this.editorMode,
    this.snapshot,
    this.selectedItemId,
    this.errorMessage,
    this.infoMessage,
    this.isSaving = false,
  });

  final Status status;
  final TodayEditorMode editorMode;
  final TodaySubmissionSnapshot? snapshot;
  final String? selectedItemId;
  final String? errorMessage;
  final String? infoMessage;
  final bool isSaving;

  SubmissionItemRecord? get selectedItem {
    final items = snapshot?.submission?.items ?? const <SubmissionItemRecord>[];
    if (selectedItemId == null) {
      return null;
    }
    for (final item in items) {
      if (item.id == selectedItemId) {
        return item;
      }
    }
    return null;
  }

  TodaySubmissionState copyWith({
    Status? status,
    TodayEditorMode? editorMode,
    TodaySubmissionSnapshot? snapshot,
    String? selectedItemId,
    bool clearSelectedItem = false,
    String? errorMessage,
    String? infoMessage,
    bool? isSaving,
  }) {
    return TodaySubmissionState(
      status: status ?? this.status,
      editorMode: editorMode ?? this.editorMode,
      snapshot: snapshot ?? this.snapshot,
      selectedItemId: clearSelectedItem
          ? null
          : selectedItemId ?? this.selectedItemId,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    status,
    editorMode,
    snapshot,
    selectedItemId,
    errorMessage,
    infoMessage,
    isSaving,
  ];
}

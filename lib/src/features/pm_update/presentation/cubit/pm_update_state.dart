import 'package:equatable/equatable.dart';

import '../../../../common/data/enums/status.dart';
import '../../domain/entity/pm_summary.dart';

class PmUpdateState extends Equatable {
  const PmUpdateState({
    required this.status,
    this.summary,
    this.itemStatuses = const {},
    this.subtaskStatuses = const {},
    this.finalNote = '',
    this.errorMessage,
    this.infoMessage,
    this.isSaving = false,
  });

  final Status status;
  final PmSummary? summary;
  final Map<String, String> itemStatuses;
  final Map<String, String?> subtaskStatuses;
  final String finalNote;
  final String? errorMessage;
  final String? infoMessage;
  final bool isSaving;

  PmUpdateState copyWith({
    Status? status,
    PmSummary? summary,
    Map<String, String>? itemStatuses,
    Map<String, String?>? subtaskStatuses,
    String? finalNote,
    String? errorMessage,
    String? infoMessage,
    bool? isSaving,
  }) {
    return PmUpdateState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      itemStatuses: itemStatuses ?? this.itemStatuses,
      subtaskStatuses: subtaskStatuses ?? this.subtaskStatuses,
      finalNote: finalNote ?? this.finalNote,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    status,
    summary,
    itemStatuses,
    subtaskStatuses,
    finalNote,
    errorMessage,
    infoMessage,
    isSaving,
  ];
}

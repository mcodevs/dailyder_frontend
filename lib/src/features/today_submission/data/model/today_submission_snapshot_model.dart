import '../../domain/entity/submission_record.dart';
import '../../domain/entity/today_submission_snapshot.dart';

class TodaySubmissionSnapshotModel {
  const TodaySubmissionSnapshotModel({
    required this.workDate,
    required this.submission,
  });

  final String workDate;
  final SubmissionRecord? submission;

  factory TodaySubmissionSnapshotModel.fromJson(Map<String, dynamic> json) {
    final submissionJson = json['submission'];
    return TodaySubmissionSnapshotModel(
      workDate: json['workDate'] as String,
      submission: submissionJson is Map<String, dynamic>
          ? SubmissionRecordModel.fromJson(submissionJson).toEntity()
          : null,
    );
  }

  TodaySubmissionSnapshot toEntity() {
    return TodaySubmissionSnapshot(workDate: workDate, submission: submission);
  }
}

class SubmissionRecordModel {
  const SubmissionRecordModel({
    required this.id,
    required this.hashtag,
    required this.items,
    this.amSubmittedAt,
    this.pmSubmittedAt,
    this.finalNote,
  });

  final String id;
  final String hashtag;
  final List<SubmissionItemRecord> items;
  final String? amSubmittedAt;
  final String? pmSubmittedAt;
  final String? finalNote;

  factory SubmissionRecordModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return SubmissionRecordModel(
      id: json['id'] as String,
      hashtag: json['hashtag'] as String? ?? '',
      items: rawItems
          .map(
            (item) => SubmissionItemRecordModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList(),
      amSubmittedAt: json['amSubmittedAt'] as String?,
      pmSubmittedAt: json['pmSubmittedAt'] as String?,
      finalNote: json['finalNote'] as String?,
    );
  }

  SubmissionRecord toEntity() {
    return SubmissionRecord(
      id: id,
      hashtag: hashtag,
      items: items,
      amSubmittedAt: amSubmittedAt,
      pmSubmittedAt: pmSubmittedAt,
      finalNote: finalNote,
    );
  }
}

class SubmissionItemRecordModel {
  const SubmissionItemRecordModel({
    required this.id,
    required this.projectName,
    required this.taskName,
    required this.sortOrder,
    required this.subtasks,
    required this.subtaskNames,
    this.status,
  });

  final String id;
  final String projectName;
  final String taskName;
  final int sortOrder;
  final List<SubmissionSubtaskRecord> subtasks;
  final List<String> subtaskNames;
  final String? status;

  factory SubmissionItemRecordModel.fromJson(Map<String, dynamic> json) {
    final rawSubtasks = json['subtasks'] as List<dynamic>? ?? const [];
    final rawSubtaskNames = json['subtaskNames'] as List<dynamic>? ?? const [];
    return SubmissionItemRecordModel(
      id: json['id'] as String,
      projectName: json['projectName'] as String,
      taskName: json['taskName'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      subtasks: rawSubtasks
          .map(
            (item) => SubmissionSubtaskRecordModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList(),
      subtaskNames: rawSubtaskNames.map((item) => item.toString()).toList(),
      status: json['status'] as String?,
    );
  }

  SubmissionItemRecord toEntity() {
    return SubmissionItemRecord(
      id: id,
      projectName: projectName,
      taskName: taskName,
      sortOrder: sortOrder,
      subtasks: subtasks,
      subtaskNames: subtaskNames,
      status: status,
    );
  }
}

class SubmissionSubtaskRecordModel {
  const SubmissionSubtaskRecordModel({
    required this.id,
    required this.name,
    required this.sortOrder,
    this.status,
  });

  final String id;
  final String name;
  final int sortOrder;
  final String? status;

  factory SubmissionSubtaskRecordModel.fromJson(Map<String, dynamic> json) {
    return SubmissionSubtaskRecordModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      status: json['status'] as String?,
    );
  }

  SubmissionSubtaskRecord toEntity() {
    return SubmissionSubtaskRecord(
      id: id,
      name: name,
      sortOrder: sortOrder,
      status: status,
    );
  }
}

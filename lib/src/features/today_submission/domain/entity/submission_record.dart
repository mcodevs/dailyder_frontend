import 'package:equatable/equatable.dart';

class SubmissionSubtaskRecord extends Equatable {
  const SubmissionSubtaskRecord({
    required this.id,
    required this.name,
    required this.sortOrder,
    this.status,
  });

  final String id;
  final String name;
  final int sortOrder;
  final String? status;

  @override
  List<Object?> get props => [id, name, sortOrder, status];
}

class SubmissionItemRecord extends Equatable {
  const SubmissionItemRecord({
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

  @override
  List<Object?> get props => [
    id,
    projectName,
    taskName,
    sortOrder,
    subtasks,
    subtaskNames,
    status,
  ];
}

class SubmissionRecord extends Equatable {
  const SubmissionRecord({
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

  @override
  List<Object?> get props => [
    id,
    hashtag,
    items,
    amSubmittedAt,
    pmSubmittedAt,
    finalNote,
  ];
}

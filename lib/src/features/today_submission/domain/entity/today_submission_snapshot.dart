import 'package:equatable/equatable.dart';

import 'submission_record.dart';

class TodaySubmissionSnapshot extends Equatable {
  const TodaySubmissionSnapshot({
    required this.workDate,
    required this.submission,
  });

  final String workDate;
  final SubmissionRecord? submission;

  @override
  List<Object?> get props => [workDate, submission];
}

import 'package:equatable/equatable.dart';

import '../../../today_submission/domain/entity/submission_record.dart';

class PmSummary extends Equatable {
  const PmSummary({required this.workDate, required this.submission});

  final String workDate;
  final SubmissionRecord? submission;

  @override
  List<Object?> get props => [workDate, submission];
}

import '../../../today_submission/data/model/today_submission_snapshot_model.dart';
import '../../domain/entity/pm_summary.dart';

class PmSummaryModel {
  const PmSummaryModel({required this.workDate, required this.submission});

  final String workDate;
  final dynamic submission;

  factory PmSummaryModel.fromJson(Map<String, dynamic> json) {
    return PmSummaryModel(
      workDate: json['workDate'] as String,
      submission: json['submission'],
    );
  }

  PmSummary toEntity() {
    return PmSummary(
      workDate: workDate,
      submission: submission is Map<String, dynamic>
          ? SubmissionRecordModel.fromJson(
              submission as Map<String, dynamic>,
            ).toEntity()
          : null,
    );
  }
}

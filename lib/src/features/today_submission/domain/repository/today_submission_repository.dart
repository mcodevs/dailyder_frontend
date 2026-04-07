import '../entity/today_submission_snapshot.dart';

abstract class TodaySubmissionRepository {
  Future<TodaySubmissionSnapshot> getTodaySubmission();

  Future<bool> saveDraftItem({
    String? itemId,
    required String projectName,
    required String taskName,
    required List<String> subtaskNames,
  });

  Future<bool> deleteDraftItem(String itemId);

  Future<bool> importDraft(String rawText);

  Future<void> submitMorning();
}

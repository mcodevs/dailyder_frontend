import '../../../../core/network/api_client.dart';
import '../../domain/entity/today_submission_snapshot.dart';
import '../../domain/repository/today_submission_repository.dart';
import '../model/today_submission_snapshot_model.dart';

class TodaySubmissionRepositoryImpl implements TodaySubmissionRepository {
  TodaySubmissionRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<TodaySubmissionSnapshot> getTodaySubmission() async {
    final response = await apiClient.getMap('/api/v1/submissions/today');
    return TodaySubmissionSnapshotModel.fromJson(response).toEntity();
  }

  @override
  Future<bool> saveDraftItem({
    String? itemId,
    required String projectName,
    required String taskName,
    required List<String> subtaskNames,
  }) async {
    final payload = {
      'projectName': projectName,
      'taskName': taskName,
      'subtaskNames': subtaskNames,
    };
    final response = itemId == null
        ? await apiClient.postMap(
            '/api/v1/submissions/today/items',
            data: payload,
          )
        : await apiClient.patchMap(
            '/api/v1/submissions/today/items/$itemId',
            data: payload,
          );
    return response['pmReset'] as bool? ?? false;
  }

  @override
  Future<bool> deleteDraftItem(String itemId) async {
    final response = await apiClient.deleteMap(
      '/api/v1/submissions/today/items/$itemId',
    );
    return response['pmReset'] as bool? ?? false;
  }

  @override
  Future<bool> importDraft(String rawText) async {
    final response = await apiClient.postMap(
      '/api/v1/submissions/today/import',
      data: {'rawText': rawText},
    );
    return response['pmReset'] as bool? ?? false;
  }

  @override
  Future<void> submitMorning() async {
    await apiClient.postMap('/api/v1/submissions/today/submit-am');
  }
}

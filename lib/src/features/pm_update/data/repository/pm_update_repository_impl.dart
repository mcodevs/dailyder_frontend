import '../../../../core/network/api_client.dart';
import '../../domain/entity/pm_summary.dart';
import '../../domain/repository/pm_update_repository.dart';
import '../model/pm_summary_model.dart';

class PmUpdateRepositoryImpl implements PmUpdateRepository {
  PmUpdateRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<PmSummary> getPmSummary() async {
    final response = await apiClient.getMap('/api/v1/pm');
    return PmSummaryModel.fromJson(response).toEntity();
  }

  @override
  Future<void> savePmSummary({
    required List<ItemStatusPayload> itemStatuses,
    required List<SubtaskStatusPayload> subtaskStatuses,
    required String? finalNote,
  }) async {
    await apiClient.putMap(
      '/api/v1/pm',
      data: {
        'itemStatuses': itemStatuses
            .map((item) => {'itemId': item.itemId, 'status': item.status})
            .toList(),
        'subtaskStatuses': subtaskStatuses
            .map(
              (item) => {
                'itemId': item.itemId,
                'subtaskId': item.subtaskId,
                'status': item.status,
              },
            )
            .toList(),
        'finalNote': finalNote,
      },
    );
  }
}

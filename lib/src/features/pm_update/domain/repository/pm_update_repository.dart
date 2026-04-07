import '../entity/pm_summary.dart';

class ItemStatusPayload {
  const ItemStatusPayload({required this.itemId, required this.status});

  final String itemId;
  final String status;
}

class SubtaskStatusPayload {
  const SubtaskStatusPayload({
    required this.itemId,
    required this.subtaskId,
    required this.status,
  });

  final String itemId;
  final String subtaskId;
  final String? status;
}

abstract class PmUpdateRepository {
  Future<PmSummary> getPmSummary();

  Future<void> savePmSummary({
    required List<ItemStatusPayload> itemStatuses,
    required List<SubtaskStatusPayload> subtaskStatuses,
    required String? finalNote,
  });
}

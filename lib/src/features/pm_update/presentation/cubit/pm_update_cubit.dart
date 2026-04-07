import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/enums/status.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../../domain/usecase/get_pm_summary_use_case.dart';
import '../../domain/usecase/save_pm_summary_use_case.dart';
import '../../domain/repository/pm_update_repository.dart';
import 'pm_update_state.dart';

class PmUpdateCubit extends Cubit<PmUpdateState> {
  PmUpdateCubit({
    required this.getPmSummaryUseCase,
    required this.savePmSummaryUseCase,
  }) : super(const PmUpdateState(status: Status.initial));

  final GetPmSummaryUseCase getPmSummaryUseCase;
  final SavePmSummaryUseCase savePmSummaryUseCase;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    final result = await getPmSummaryUseCase.execute(const NoParams());
    result.fold(
      onLeft: (failure) {
        emit(
          state.copyWith(status: Status.error, errorMessage: failure.message),
        );
      },
      onRight: (summary) {
        final itemStatuses = <String, String>{};
        final subtaskStatuses = <String, String?>{};
        for (final item in summary.submission?.items ?? const []) {
          if (item.status != null) {
            itemStatuses[item.id] = item.status!;
          }
          for (final subtask in item.subtasks) {
            subtaskStatuses[subtask.id] = subtask.status;
          }
        }
        emit(
          state.copyWith(
            status: Status.success,
            summary: summary,
            itemStatuses: itemStatuses,
            subtaskStatuses: subtaskStatuses,
            finalNote: summary.submission?.finalNote ?? '',
          ),
        );
      },
    );
  }

  void updateItemStatus({required String itemId, required String status}) {
    final next = Map<String, String>.from(state.itemStatuses);
    next[itemId] = status;
    emit(
      state.copyWith(itemStatuses: next, infoMessage: null, errorMessage: null),
    );
  }

  void updateSubtaskStatus({
    required String subtaskId,
    required String? status,
  }) {
    final next = Map<String, String?>.from(state.subtaskStatuses);
    next[subtaskId] = status;
    emit(
      state.copyWith(
        subtaskStatuses: next,
        infoMessage: null,
        errorMessage: null,
      ),
    );
  }

  void updateFinalNote(String finalNote) {
    emit(
      state.copyWith(
        finalNote: finalNote,
        infoMessage: null,
        errorMessage: null,
      ),
    );
  }

  Future<void> save() async {
    final submission = state.summary?.submission;
    if (submission == null) {
      emit(
        state.copyWith(errorMessage: 'PM update uchun AM tasklar topilmadi.'),
      );
      return;
    }
    emit(state.copyWith(isSaving: true, errorMessage: null, infoMessage: null));
    final itemStatuses = submission.items
        .map(
          (item) => ItemStatusPayload(
            itemId: item.id,
            status: state.itemStatuses[item.id] ?? '',
          ),
        )
        .toList();
    final subtaskStatuses = submission.items
        .expand(
          (item) => item.subtasks.map(
            (subtask) => SubtaskStatusPayload(
              itemId: item.id,
              subtaskId: subtask.id,
              status: state.subtaskStatuses[subtask.id],
            ),
          ),
        )
        .toList();
    final result = await savePmSummaryUseCase.execute(
      SavePmSummaryParams(
        itemStatuses: itemStatuses,
        subtaskStatuses: subtaskStatuses,
        finalNote: state.finalNote.trim().isEmpty
            ? null
            : state.finalNote.trim(),
      ),
    );
    await result.fold(
      onLeft: (failure) async {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      onRight: (_) async {
        emit(
          state.copyWith(isSaving: false, infoMessage: 'PM update saqlandi.'),
        );
        await load();
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/enums/status.dart';
import '../../../../common/data/usecase/usecase.dart';
import '../../domain/usecase/delete_draft_item_use_case.dart';
import '../../domain/usecase/get_today_submission_use_case.dart';
import '../../domain/usecase/import_today_submission_use_case.dart';
import '../../domain/usecase/save_draft_item_use_case.dart';
import '../../domain/usecase/submit_morning_use_case.dart';
import 'today_submission_state.dart';

class TodaySubmissionCubit extends Cubit<TodaySubmissionState> {
  TodaySubmissionCubit({
    required this.getTodaySubmissionUseCase,
    required this.saveDraftItemUseCase,
    required this.deleteDraftItemUseCase,
    required this.importTodaySubmissionUseCase,
    required this.submitMorningUseCase,
  }) : super(
         const TodaySubmissionState(
           status: Status.initial,
           editorMode: TodayEditorMode.overview,
         ),
       );

  final GetTodaySubmissionUseCase getTodaySubmissionUseCase;
  final SaveDraftItemUseCase saveDraftItemUseCase;
  final DeleteDraftItemUseCase deleteDraftItemUseCase;
  final ImportTodaySubmissionUseCase importTodaySubmissionUseCase;
  final SubmitMorningUseCase submitMorningUseCase;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        infoMessage: state.infoMessage,
      ),
    );
    final result = await getTodaySubmissionUseCase.execute(const NoParams());
    result.fold(
      onLeft: (failure) {
        emit(
          state.copyWith(status: Status.error, errorMessage: failure.message),
        );
      },
      onRight: (snapshot) {
        emit(
          state.copyWith(
            status: Status.success,
            snapshot: snapshot,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void showCreateEditor() {
    emit(
      state.copyWith(
        editorMode: TodayEditorMode.create,
        clearSelectedItem: true,
        infoMessage: null,
        errorMessage: null,
      ),
    );
  }

  void showEditEditor(String itemId) {
    emit(
      state.copyWith(
        editorMode: TodayEditorMode.edit,
        selectedItemId: itemId,
        infoMessage: null,
        errorMessage: null,
      ),
    );
  }

  void showImportEditor() {
    emit(
      state.copyWith(
        editorMode: TodayEditorMode.importText,
        clearSelectedItem: true,
        infoMessage: null,
        errorMessage: null,
      ),
    );
  }

  void closeEditor() {
    emit(
      state.copyWith(
        editorMode: TodayEditorMode.overview,
        clearSelectedItem: true,
        errorMessage: null,
      ),
    );
  }

  Future<void> saveItem({
    String? itemId,
    required String projectName,
    required String taskName,
    required List<String> subtaskNames,
  }) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, infoMessage: null));
    final result = await saveDraftItemUseCase.execute(
      SaveDraftItemParams(
        itemId: itemId,
        projectName: projectName,
        taskName: taskName,
        subtaskNames: subtaskNames,
      ),
    );
    await result.fold(
      onLeft: (failure) async {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      onRight: (pmReset) async {
        emit(
          state.copyWith(
            isSaving: false,
            editorMode: TodayEditorMode.overview,
            clearSelectedItem: true,
            infoMessage: pmReset
                ? 'Task saqlandi. PM update reset qilindi.'
                : 'Task saqlandi.',
          ),
        );
        await load();
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, infoMessage: null));
    final result = await deleteDraftItemUseCase.execute(itemId);
    await result.fold(
      onLeft: (failure) async {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      onRight: (pmReset) async {
        emit(
          state.copyWith(
            isSaving: false,
            editorMode: TodayEditorMode.overview,
            clearSelectedItem: true,
            infoMessage: pmReset
                ? 'Task o‘chirildi. PM update reset qilindi.'
                : 'Task o‘chirildi.',
          ),
        );
        await load();
      },
    );
  }

  Future<void> importDraft(String rawText) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, infoMessage: null));
    final result = await importTodaySubmissionUseCase.execute(rawText);
    await result.fold(
      onLeft: (failure) async {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      onRight: (pmReset) async {
        emit(
          state.copyWith(
            isSaving: false,
            editorMode: TodayEditorMode.overview,
            infoMessage: pmReset
                ? 'Import tugadi. PM update reset qilindi.'
                : 'Import tugadi.',
          ),
        );
        await load();
      },
    );
  }

  Future<void> submitMorning() async {
    emit(state.copyWith(isSaving: true, errorMessage: null, infoMessage: null));
    final result = await submitMorningUseCase.execute(const NoParams());
    await result.fold(
      onLeft: (failure) async {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      onRight: (_) async {
        emit(
          state.copyWith(isSaving: false, infoMessage: 'AM tasklar yuborildi.'),
        );
        await load();
      },
    );
  }
}

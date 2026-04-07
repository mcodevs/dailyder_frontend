import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailyder_frontend/src/features/today_submission/domain/entity/today_submission_snapshot.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/repository/today_submission_repository.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/usecase/delete_draft_item_use_case.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/usecase/get_today_submission_use_case.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/usecase/import_today_submission_use_case.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/usecase/save_draft_item_use_case.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/usecase/submit_morning_use_case.dart';
import 'package:dailyder_frontend/src/features/today_submission/presentation/cubit/today_submission_cubit.dart';
import 'package:dailyder_frontend/src/features/today_submission/presentation/screen/today_submission_screen.dart';

class FakeTodaySubmissionRepository implements TodaySubmissionRepository {
  @override
  Future<bool> deleteDraftItem(String itemId) async => false;

  @override
  Future<TodaySubmissionSnapshot> getTodaySubmission() async {
    return const TodaySubmissionSnapshot(
      workDate: '2026-04-07',
      submission: null,
    );
  }

  @override
  Future<bool> importDraft(String rawText) async => false;

  @override
  Future<bool> saveDraftItem({
    String? itemId,
    required String projectName,
    required String taskName,
    required List<String> subtaskNames,
  }) async => false;

  @override
  Future<void> submitMorning() async {}
}

void main() {
  testWidgets(
    'TodaySubmissionScreen renders empty state for missing submission',
    (tester) async {
      final repository = FakeTodaySubmissionRepository();
      final cubit = TodaySubmissionCubit(
        getTodaySubmissionUseCase: GetTodaySubmissionUseCase(
          repository: repository,
        ),
        saveDraftItemUseCase: SaveDraftItemUseCase(repository: repository),
        deleteDraftItemUseCase: DeleteDraftItemUseCase(repository: repository),
        importTodaySubmissionUseCase: ImportTodaySubmissionUseCase(
          repository: repository,
        ),
        submitMorningUseCase: SubmitMorningUseCase(repository: repository),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const TodaySubmissionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hozircha task yo‘q'), findsOneWidget);
      expect(find.text('Task qo‘shish'), findsWidgets);
    },
  );
}

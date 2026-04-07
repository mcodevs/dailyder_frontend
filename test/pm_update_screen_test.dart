import 'package:dailyder_frontend/src/features/pm_update/domain/entity/pm_summary.dart';
import 'package:dailyder_frontend/src/features/pm_update/domain/repository/pm_update_repository.dart';
import 'package:dailyder_frontend/src/features/pm_update/domain/usecase/get_pm_summary_use_case.dart';
import 'package:dailyder_frontend/src/features/pm_update/domain/usecase/save_pm_summary_use_case.dart';
import 'package:dailyder_frontend/src/features/pm_update/presentation/cubit/pm_update_cubit.dart';
import 'package:dailyder_frontend/src/features/pm_update/presentation/screen/pm_update_screen.dart';
import 'package:dailyder_frontend/src/features/today_submission/domain/entity/submission_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePmUpdateRepository implements PmUpdateRepository {
  FakePmUpdateRepository({required this.summary});

  final PmSummary summary;

  List<ItemStatusPayload>? savedItemStatuses;
  List<SubtaskStatusPayload>? savedSubtaskStatuses;
  String? savedFinalNote;
  int loadCount = 0;
  int saveCount = 0;

  @override
  Future<PmSummary> getPmSummary() async {
    loadCount += 1;
    return summary;
  }

  @override
  Future<void> savePmSummary({
    required List<ItemStatusPayload> itemStatuses,
    required List<SubtaskStatusPayload> subtaskStatuses,
    required String? finalNote,
  }) async {
    saveCount += 1;
    savedItemStatuses = itemStatuses;
    savedSubtaskStatuses = subtaskStatuses;
    savedFinalNote = finalNote;
  }
}

void main() {
  testWidgets(
    'PmUpdateScreen renders dark summary and poll-like status chips',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = FakePmUpdateRepository(
        summary: const PmSummary(
          workDate: '2026-04-07',
          submission: SubmissionRecord(
            id: 'submission-1',
            hashtag: 'daily',
            items: [
              SubmissionItemRecord(
                id: 'item-1',
                projectName: 'Finance',
                taskName: 'Release',
                sortOrder: 1,
                subtasks: [
                  SubmissionSubtaskRecord(
                    id: 'subtask-1',
                    name: 'Bug fix',
                    sortOrder: 1,
                  ),
                ],
                subtaskNames: ['Bug fix'],
              ),
            ],
          ),
        ),
      );

      final cubit = PmUpdateCubit(
        getPmSummaryUseCase: GetPmSummaryUseCase(repository: repository),
        savePmSummaryUseCase: SavePmSummaryUseCase(repository: repository),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: const PmUpdateScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PM update'), findsWidgets);
      expect(find.text('2026-04-07'), findsOneWidget);
      expect(find.text('Finance'), findsOneWidget);
      expect(find.text('Release'), findsOneWidget);
      expect(find.text('Bug fix'), findsOneWidget);
      expect(find.byKey(const ValueKey('choice-completed-d')), findsOneWidget);
      expect(find.byKey(const ValueKey('choice-warning-c')), findsOneWidget);
    },
  );

  testWidgets('PmUpdateScreen saves selected statuses and final note', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = FakePmUpdateRepository(
      summary: const PmSummary(
        workDate: '2026-04-07',
        submission: SubmissionRecord(
          id: 'submission-1',
          hashtag: 'daily',
          items: [
            SubmissionItemRecord(
              id: 'item-1',
              projectName: 'Finance',
              taskName: 'Release',
              sortOrder: 1,
              subtasks: [
                SubmissionSubtaskRecord(
                  id: 'subtask-1',
                  name: 'Bug fix',
                  sortOrder: 1,
                ),
              ],
              subtaskNames: ['Bug fix'],
            ),
          ],
        ),
      ),
    );

    final cubit = PmUpdateCubit(
      getPmSummaryUseCase: GetPmSummaryUseCase(repository: repository),
      savePmSummaryUseCase: SavePmSummaryUseCase(repository: repository),
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: MaterialApp(
          home: BlocProvider.value(value: cubit, child: const PmUpdateScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('choice-completed-d')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('choice-warning-c')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('pm-final-note-field')),
      '  Delivery looks good  ',
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('pm-final-save')));
    await tester.pumpAndSettle();

    expect(repository.saveCount, 1);
    expect(repository.savedFinalNote, 'Delivery looks good');
    expect(repository.savedItemStatuses, hasLength(1));
    expect(repository.savedItemStatuses!.first.itemId, 'item-1');
    expect(repository.savedItemStatuses!.first.status, 'completed');
    expect(repository.savedSubtaskStatuses, hasLength(1));
    expect(repository.savedSubtaskStatuses!.first.subtaskId, 'subtask-1');
    expect(repository.savedSubtaskStatuses!.first.status, 'warning');
  });
}

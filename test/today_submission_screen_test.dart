import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailyder_frontend/src/features/today_submission/domain/entity/submission_record.dart';
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
  FakeTodaySubmissionRepository({required this.snapshot});

  final TodaySubmissionSnapshot snapshot;

  @override
  Future<bool> deleteDraftItem(String itemId) async => false;

  @override
  Future<TodaySubmissionSnapshot> getTodaySubmission() async => snapshot;

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

TodaySubmissionCubit buildCubit(TodaySubmissionRepository repository) {
  return TodaySubmissionCubit(
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
}

Widget buildSubject({
  required TodaySubmissionCubit cubit,
  Size size = const Size(390, 844),
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      home: BlocProvider.value(
        value: cubit,
        child: const Scaffold(body: TodaySubmissionScreen()),
      ),
    ),
  );
}

TodaySubmissionSnapshot buildEmptySnapshot() {
  return const TodaySubmissionSnapshot(
    workDate: '2026-04-07',
    submission: null,
  );
}

TodaySubmissionSnapshot buildFilledSnapshot() {
  return const TodaySubmissionSnapshot(
    workDate: '2026-04-07',
    submission: SubmissionRecord(
      id: 'submission-1',
      hashtag: '#daily',
      items: [
        SubmissionItemRecord(
          id: 'item-1',
          projectName: 'Ayva Finance',
          taskName: 'Telegram poll UI',
          sortOrder: 1,
          subtasks: [
            SubmissionSubtaskRecord(
              id: 'subtask-1',
              name: 'Header polish',
              sortOrder: 1,
            ),
            SubmissionSubtaskRecord(
              id: 'subtask-2',
              name: 'Composer layout',
              sortOrder: 2,
            ),
          ],
          subtaskNames: ['Header polish', 'Composer layout'],
        ),
      ],
      amSubmittedAt: null,
      pmSubmittedAt: null,
    ),
  );
}

void main() {
  testWidgets('TodaySubmissionScreen renders empty state in the new shell', (
    tester,
  ) async {
    final cubit = buildCubit(
      FakeTodaySubmissionRepository(snapshot: buildEmptySnapshot()),
    );

    await tester.pumpWidget(buildSubject(cubit: cubit));
    await tester.pumpAndSettle();

    expect(find.text('Hozircha task yo‘q'), findsOneWidget);
    expect(find.text('Task qo‘shish'), findsOneWidget);
    expect(find.text('Matndan import'), findsOneWidget);
    expect(find.text('AM yuborish'), findsNothing);
  });

  testWidgets(
    'TodaySubmissionScreen opens the composer and adds subtask rows',
    (tester) async {
      final cubit = buildCubit(
        FakeTodaySubmissionRepository(snapshot: buildEmptySnapshot()),
      );

      await tester.pumpWidget(buildSubject(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Task qo‘shish'));
      await tester.pumpAndSettle();

      expect(find.text('Yangi task'), findsOneWidget);
      expect(find.text('Subtask qo‘shish'), findsOneWidget);
      expect(find.text('Saqlash'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));

      await tester.drag(find.byType(ListView).first, const Offset(0, -420));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Subtask qo‘shish').first);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(4));
    },
  );

  testWidgets('TodaySubmissionScreen renders grouped task rows', (
    tester,
  ) async {
    final cubit = buildCubit(
      FakeTodaySubmissionRepository(snapshot: buildFilledSnapshot()),
    );

    await tester.pumpWidget(
      buildSubject(cubit: cubit, size: const Size(1024, 900)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Draft tasklar'), findsOneWidget);
    expect(find.text('Ayva Finance'), findsOneWidget);
    expect(find.text('Telegram poll UI'), findsOneWidget);
    expect(find.text('Header polish'), findsOneWidget);
    expect(find.text('Composer layout'), findsOneWidget);
    expect(find.text('AM yuborish'), findsOneWidget);
    expect(find.byTooltip('Tahrirlash'), findsOneWidget);
    expect(find.byTooltip('O‘chirish'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/app_status_view.dart';
import '../cubit/today_submission_cubit.dart';
import '../cubit/today_submission_state.dart';
import '../widget/today_submission_board.dart';

class TodaySubmissionScreen extends StatefulWidget {
  const TodaySubmissionScreen({super.key});

  @override
  State<TodaySubmissionScreen> createState() => TodaySubmissionScreenState();
}

class TodaySubmissionScreenState extends State<TodaySubmissionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodaySubmissionCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodaySubmissionCubit, TodaySubmissionState>(
      builder: (context, state) {
        if (state.status.isInitial ||
            state.status.isLoading && state.snapshot == null) {
          return const AppStatusView(
            title: 'Bugungi tasklar',
            message: 'Tasklar yuklanmoqda...',
          );
        }
        if (state.status.isError && state.snapshot == null) {
          return AppStatusView(
            title: 'Xato',
            message: state.errorMessage ?? 'Tasklarni yuklab bo‘lmadi.',
            actionLabel: 'Qayta urinish',
            onActionPressed: () {
              context.read<TodaySubmissionCubit>().load();
            },
          );
        }
        return Column(
          children: [
            if (state.infoMessage != null || state.errorMessage != null)
              MaterialBanner(
                content: Text(state.infoMessage ?? state.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.read<TodaySubmissionCubit>().load();
                    },
                    child: const Text('Yangilash'),
                  ),
                ],
              ),
            Expanded(
              child: TodaySubmissionBoard(
                state: state,
                onCreatePressed: () {
                  context.read<TodaySubmissionCubit>().showCreateEditor();
                },
                onImportPressed: () {
                  context.read<TodaySubmissionCubit>().showImportEditor();
                },
                onEditPressed: (itemId) {
                  context.read<TodaySubmissionCubit>().showEditEditor(itemId);
                },
                onDeletePressed: (itemId) {
                  context.read<TodaySubmissionCubit>().deleteItem(itemId);
                },
                onSubmitPressed: () {
                  context.read<TodaySubmissionCubit>().submitMorning();
                },
                onCancelEditorPressed: () {
                  context.read<TodaySubmissionCubit>().closeEditor();
                },
                onSaveDraftPressed:
                    ({
                      String? itemId,
                      required String projectName,
                      required String taskName,
                      required List<String> subtaskNames,
                    }) {
                      context.read<TodaySubmissionCubit>().saveItem(
                        itemId: itemId,
                        projectName: projectName,
                        taskName: taskName,
                        subtaskNames: subtaskNames,
                      );
                    },
                onImportDraftPressed: (rawText) {
                  context.read<TodaySubmissionCubit>().importDraft(rawText);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

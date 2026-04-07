import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/today_submission_cubit.dart';
import '../cubit/today_submission_state.dart';
import '../widget/today_submission_board.dart';
import '../widget/today_submission_feedback_card.dart';
import '../widget/today_submission_theme.dart';

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
    return TodaySubmissionTheme(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1016), Color(0xFF101722), Color(0xFF0B1016)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: BlocBuilder<TodaySubmissionCubit, TodaySubmissionState>(
              builder: (context, state) {
                if (state.status.isInitial ||
                    state.status.isLoading && state.snapshot == null) {
                  return TodayStatusView(
                    title: 'Bugungi tasklar',
                    message: 'Tasklar yuklanmoqda...',
                    isLoading: true,
                  );
                }
                if (state.status.isError && state.snapshot == null) {
                  return TodayStatusView(
                    title: 'Xato',
                    message: state.errorMessage ?? 'Tasklarni yuklab bo‘lmadi.',
                    actionLabel: 'Qayta urinish',
                    onActionPressed: () {
                      context.read<TodaySubmissionCubit>().load();
                    },
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.infoMessage != null || state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TodayInlineNotice(
                          message: state.infoMessage ?? state.errorMessage!,
                          isError: state.errorMessage != null,
                        ),
                      ),
                    Expanded(
                      child: TodaySubmissionBoard(
                        state: state,
                        onCreatePressed: () {
                          context
                              .read<TodaySubmissionCubit>()
                              .showCreateEditor();
                        },
                        onImportPressed: () {
                          context
                              .read<TodaySubmissionCubit>()
                              .showImportEditor();
                        },
                        onEditPressed: (itemId) {
                          context.read<TodaySubmissionCubit>().showEditEditor(
                            itemId,
                          );
                        },
                        onDeletePressed: (itemId) {
                          context.read<TodaySubmissionCubit>().deleteItem(
                            itemId,
                          );
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
                          context.read<TodaySubmissionCubit>().importDraft(
                            rawText,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/app_status_view.dart';
import '../cubit/pm_update_cubit.dart';
import '../cubit/pm_update_state.dart';
import '../widget/pm_final_note_card.dart';
import '../widget/pm_status_selector_card.dart';

class PmUpdateScreen extends StatefulWidget {
  const PmUpdateScreen({super.key});

  @override
  State<PmUpdateScreen> createState() => PmUpdateScreenState();
}

class PmUpdateScreenState extends State<PmUpdateScreen> {
  late final TextEditingController finalNoteController;

  @override
  void initState() {
    super.initState();
    finalNoteController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PmUpdateCubit>().load();
    });
  }

  @override
  void dispose() {
    finalNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PmUpdateCubit, PmUpdateState>(
      listener: (context, state) {
        if (finalNoteController.text != state.finalNote) {
          finalNoteController.text = state.finalNote;
        }
      },
      builder: (context, state) {
        if (state.status.isInitial ||
            state.status.isLoading && state.summary == null) {
          return const AppStatusView(
            title: 'PM update',
            message: 'PM holati yuklanmoqda...',
          );
        }
        if (state.status.isError && state.summary == null) {
          return AppStatusView(
            title: 'PM update',
            message: state.errorMessage ?? 'PM holatini yuklab bo‘lmadi.',
            actionLabel: 'Qayta urinish',
            onActionPressed: () {
              context.read<PmUpdateCubit>().load();
            },
          );
        }
        final submission = state.summary?.submission;
        if (submission == null) {
          return const AppStatusView(
            title: 'PM update',
            message: 'Avval AM tasklarni yuboring.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (state.infoMessage != null || state.errorMessage != null)
              MaterialBanner(
                content: Text(state.infoMessage ?? state.errorMessage!),
                actions: const [SizedBox.shrink()],
              ),
            for (final item in submission.items) ...[
              PmStatusSelectorCard(
                item: item,
                itemStatus: state.itemStatuses[item.id],
                subtaskStatuses: state.subtaskStatuses,
                onItemStatusChanged: (value) {
                  if (value != null) {
                    context.read<PmUpdateCubit>().updateItemStatus(
                      itemId: item.id,
                      status: value,
                    );
                  }
                },
                onSubtaskStatusChanged: (value, subtask) {
                  context.read<PmUpdateCubit>().updateSubtaskStatus(
                    subtaskId: subtask.id,
                    status: value,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            PmFinalNoteCard(
              controller: finalNoteController,
              isSaving: state.isSaving,
              onSavePressed: () {
                context.read<PmUpdateCubit>().updateFinalNote(
                  finalNoteController.text,
                );
                context.read<PmUpdateCubit>().save();
              },
            ),
          ],
        );
      },
    );
  }
}

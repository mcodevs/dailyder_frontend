import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pm_update_cubit.dart';
import '../cubit/pm_update_state.dart';
import '../widget/pm_final_note_card.dart';
import '../widget/pm_status_selector_card.dart';
import '../widget/pm_update_state_panel.dart';
import '../widget/pm_update_summary_card.dart';
import '../widget/pm_update_theme.dart';

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
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: PmUpdateTheme.shellDecoration(),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -80,
              child: PmBackdropOrb(
                color: PmUpdateTheme.backgroundGlow.withValues(alpha: 0.55),
                size: 240,
              ),
            ),
            Positioned(
              top: 90,
              left: -60,
              child: PmBackdropOrb(
                color: PmUpdateTheme.accent.withValues(alpha: 0.12),
                size: 180,
              ),
            ),
            BlocConsumer<PmUpdateCubit, PmUpdateState>(
              listener: (context, state) {
                if (finalNoteController.text != state.finalNote) {
                  finalNoteController.text = state.finalNote;
                }
              },
              builder: (context, state) {
                final submission = state.summary?.submission;
                if (state.status.isInitial ||
                    state.status.isLoading && state.summary == null) {
                  return const PmUpdateCenteredPanel(
                    child: PmUpdateStatePanel(
                      title: 'PM update yuklanmoqda',
                      message: 'Bugungi AM draft va subtasks tayyorlanmoqda.',
                      isLoading: true,
                    ),
                  );
                }
                if (state.status.isError && state.summary == null) {
                  return PmUpdateCenteredPanel(
                    child: PmUpdateStatePanel(
                      title: 'PM update ochilmadi',
                      message:
                          state.errorMessage ??
                          'PM holatini yuklab bo‘lmadi. Qayta urinib ko‘ring.',
                      actionLabel: 'Qayta urinish',
                      onActionPressed: () {
                        context.read<PmUpdateCubit>().load();
                      },
                    ),
                  );
                }
                if (submission == null) {
                  return const PmUpdateCenteredPanel(
                    child: PmUpdateStatePanel(
                      title: 'PM update',
                      message: 'Avval AM tasklarni yuboring.',
                    ),
                  );
                }
                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          PmUpdateSummaryCard(
                            summary: state.summary!,
                            state: state,
                          ),
                          const SizedBox(height: 16),
                          if (state.infoMessage != null ||
                              state.errorMessage != null)
                            PmUpdateNoticeCard(
                              message: state.infoMessage ?? state.errorMessage!,
                              isError: state.errorMessage != null,
                            ),
                          if (state.infoMessage != null ||
                              state.errorMessage != null)
                            const SizedBox(height: 16),
                          for (final item in submission.items) ...[
                            PmStatusSelectorCard(
                              item: item,
                              itemStatus: state.itemStatuses[item.id],
                              subtaskStatuses: state.subtaskStatuses,
                              onItemStatusChanged: (value) {
                                context.read<PmUpdateCubit>().updateItemStatus(
                                  itemId: item.id,
                                  status: value ?? '',
                                );
                              },
                              onSubtaskStatusChanged: (value, subtask) {
                                context
                                    .read<PmUpdateCubit>()
                                    .updateSubtaskStatus(
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
                          const SizedBox(height: 24),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PmUpdateCenteredPanel extends StatelessWidget {
  const PmUpdateCenteredPanel({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: child,
        ),
      ),
    );
  }
}

class PmUpdateNoticeCard extends StatelessWidget {
  const PmUpdateNoticeCard({
    required this.message,
    required this.isError,
    super.key,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final borderColor = isError ? PmUpdateTheme.danger : PmUpdateTheme.accent;
    final backgroundColor = isError
        ? Color.lerp(PmUpdateTheme.danger, PmUpdateTheme.surface, 0.84)
        : Color.lerp(PmUpdateTheme.accent, PmUpdateTheme.surface, 0.84);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.38)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: borderColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PmUpdateTheme.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PmBackdropOrb extends StatelessWidget {
  const PmBackdropOrb({required this.color, required this.size, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}

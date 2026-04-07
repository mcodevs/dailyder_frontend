import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/app_status_view.dart';
import '../cubit/admin_console_cubit.dart';
import '../cubit/admin_console_state.dart';
import '../widget/admin_group_binding_section.dart';
import '../widget/admin_metrics_section.dart';
import '../widget/admin_overview_section.dart';
import '../widget/admin_pending_section.dart';
import '../widget/admin_reminders_section.dart';
import '../widget/admin_users_section.dart';
import '../widget/admin_warning_form_section.dart';

class AdminConsoleScreen extends StatefulWidget {
  const AdminConsoleScreen({required this.section, super.key});

  final AdminSection section;

  @override
  State<AdminConsoleScreen> createState() => AdminConsoleScreenState();
}

class AdminConsoleScreenState extends State<AdminConsoleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSection();
    });
  }

  void loadSection() {
    final cubit = context.read<AdminConsoleCubit>();
    switch (widget.section) {
      case AdminSection.overview:
        cubit.loadOverview();
        return;
      case AdminSection.pending:
        cubit.loadPending();
        return;
      case AdminSection.metrics:
        cubit.loadMetrics();
        return;
      case AdminSection.users:
        cubit.loadUsers();
        return;
      case AdminSection.reminders:
        cubit.loadOverview();
        return;
      case AdminSection.warnings:
        cubit.loadOverview();
        return;
      case AdminSection.groupBinding:
        cubit.loadOverview();
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminConsoleCubit, AdminConsoleState>(
      builder: (context, state) {
        if (state.status.isInitial ||
            state.status.isLoading && buildSectionWidget(state) == null) {
          return const AppStatusView(
            title: 'Admin',
            message: 'Admin ma’lumotlari yuklanmoqda...',
          );
        }
        if (state.status.isError && buildSectionWidget(state) == null) {
          return AppStatusView(
            title: 'Admin',
            message:
                state.errorMessage ?? 'Admin ma’lumotlarini yuklab bo‘lmadi.',
            actionLabel: 'Qayta urinish',
            onActionPressed: () {
              context.read<AdminConsoleCubit>().loadOverview();
            },
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
            if (buildSectionWidget(state) != null) buildSectionWidget(state)!,
          ],
        );
      },
    );
  }

  Widget? buildSectionWidget(AdminConsoleState state) {
    switch (widget.section) {
      case AdminSection.overview:
        final overview = state.overview;
        return overview == null
            ? null
            : AdminOverviewSection(overview: overview);
      case AdminSection.pending:
        final snapshot = state.pendingSnapshot;
        return snapshot == null
            ? null
            : AdminPendingSection(snapshot: snapshot);
      case AdminSection.metrics:
        final snapshot = state.metricsSnapshot;
        return snapshot == null
            ? null
            : AdminMetricsSection(snapshot: snapshot);
      case AdminSection.users:
        return AdminUsersSection(users: state.users);
      case AdminSection.reminders:
        return AdminRemindersSection(
          isBusy: state.isBusy,
          onReminderPressed: (period) {
            context.read<AdminConsoleCubit>().sendReminder(period);
          },
        );
      case AdminSection.warnings:
        return AdminWarningFormSection(
          isBusy: state.isBusy,
          onSubmitPressed:
              ({required String developerUsername, required String reason}) {
                context.read<AdminConsoleCubit>().createWarning(
                  developerUsername: developerUsername,
                  reason: reason,
                );
              },
        );
      case AdminSection.groupBinding:
        return AdminGroupBindingSection(
          isBusy: state.isBusy,
          bindingIntent: state.bindingIntent,
          onCreatePressed: () {
            context.read<AdminConsoleCubit>().createBindingIntent();
          },
        );
    }
  }
}

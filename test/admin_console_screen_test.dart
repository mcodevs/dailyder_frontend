import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailyder_frontend/src/features/admin_console/domain/entity/admin_console_entities.dart';
import 'package:dailyder_frontend/src/features/admin_console/domain/repository/admin_console_repository.dart';
import 'package:dailyder_frontend/src/features/admin_console/presentation/cubit/admin_console_cubit.dart';
import 'package:dailyder_frontend/src/features/admin_console/presentation/cubit/admin_console_state.dart';
import 'package:dailyder_frontend/src/features/admin_console/presentation/screen/admin_console_screen.dart';

class FakeAdminConsoleRepository implements AdminConsoleRepository {
  @override
  Future<GroupBindingIntentResult> createGroupBindingIntent() async {
    return const GroupBindingIntentResult(
      token: 'token',
      bindCommand: '/bind_group token',
      expiresAt: '2026-04-07T12:00:00Z',
    );
  }

  @override
  Future<WarningResult> createWarning({
    required String developerUsername,
    required String reason,
  }) async {
    return const WarningResult(
      warningId: 'warning-1',
      reason: 'Reason',
      privateDeliveryFailed: false,
    );
  }

  @override
  Future<MetricsReportSnapshot> getMetrics() async {
    return const MetricsReportSnapshot(
      startDate: '2026-03-09',
      endDate: '2026-04-07',
      days: 30,
      users: [],
    );
  }

  @override
  Future<AdminOverview> getOverview() async {
    return const AdminOverview(
      adminCount: 2,
      onboardedUserCount: 5,
      amScheduler: '09:00',
      pmScheduler: '17:00',
      groupTitle: 'Dailyder Group',
      messageThreadId: 14,
    );
  }

  @override
  Future<PendingUsersSnapshot> getPending() async {
    return const PendingUsersSnapshot(
      workDate: '2026-04-07',
      amPendingUsers: [],
      pmPendingUsers: [],
    );
  }

  @override
  Future<List<AdminUserRecord>> getUsers() async => const [];

  @override
  Future<int> sendReminder(String period) async => 1;
}

void main() {
  testWidgets('AdminConsoleScreen renders overview content', (tester) async {
    final cubit = AdminConsoleCubit(repository: FakeAdminConsoleRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const AdminConsoleScreen(section: AdminSection.overview),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Admin overview'), findsOneWidget);
    expect(find.text('Group: Dailyder Group'), findsOneWidget);
  });
}

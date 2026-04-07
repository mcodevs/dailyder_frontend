import '../entity/admin_console_entities.dart';

abstract class AdminConsoleRepository {
  Future<AdminOverview> getOverview();

  Future<PendingUsersSnapshot> getPending();

  Future<MetricsReportSnapshot> getMetrics();

  Future<List<AdminUserRecord>> getUsers();

  Future<int> sendReminder(String period);

  Future<WarningResult> createWarning({
    required String developerUsername,
    required String reason,
  });

  Future<GroupBindingIntentResult> createGroupBindingIntent();
}

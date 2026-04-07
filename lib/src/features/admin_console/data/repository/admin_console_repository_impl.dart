import '../../../../core/network/api_client.dart';
import '../../domain/entity/admin_console_entities.dart';
import '../../domain/repository/admin_console_repository.dart';
import '../model/admin_console_models.dart';

class AdminConsoleRepositoryImpl implements AdminConsoleRepository {
  AdminConsoleRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<AdminOverview> getOverview() async {
    return AdminConsoleModels.parseOverview(
      await apiClient.getMap('/api/v1/admin/readiness'),
    );
  }

  @override
  Future<PendingUsersSnapshot> getPending() async {
    return AdminConsoleModels.parsePending(
      await apiClient.getMap('/api/v1/admin/pending'),
    );
  }

  @override
  Future<MetricsReportSnapshot> getMetrics() async {
    return AdminConsoleModels.parseMetrics(
      await apiClient.getMap('/api/v1/admin/metrics'),
    );
  }

  @override
  Future<List<AdminUserRecord>> getUsers() async {
    final response = await apiClient.getMap('/api/v1/admin/users');
    final users = response['users'] as List<dynamic>? ?? const [];
    return users
        .map(
          (item) => AdminConsoleModels.parseUser(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<int> sendReminder(String period) async {
    final response = await apiClient.postMap('/api/v1/admin/reminders/$period');
    return response['sentCount'] as int? ?? 0;
  }

  @override
  Future<WarningResult> createWarning({
    required String developerUsername,
    required String reason,
  }) async {
    final response = await apiClient.postMap(
      '/api/v1/admin/warnings',
      data: {'developerUsername': developerUsername, 'reason': reason},
    );
    return AdminConsoleModels.parseWarningResult(response);
  }

  @override
  Future<GroupBindingIntentResult> createGroupBindingIntent() async {
    final response = await apiClient.postMap(
      '/api/v1/admin/group-binding/intents',
    );
    return AdminConsoleModels.parseBindingIntent(response);
  }
}

import '../../domain/entity/admin_console_entities.dart';

class AdminConsoleModels {
  const AdminConsoleModels._();

  static AdminOverview parseOverview(Map<String, dynamic> json) {
    final binding = json['groupBinding'];
    return AdminOverview(
      adminCount: json['adminCount'] as int? ?? 0,
      onboardedUserCount: json['onboardedUserCount'] as int? ?? 0,
      amScheduler: json['amScheduler'] as String? ?? '',
      pmScheduler: json['pmScheduler'] as String? ?? '',
      groupTitle: binding is Map<String, dynamic>
          ? binding['title'] as String?
          : null,
      messageThreadId: binding is Map<String, dynamic>
          ? binding['messageThreadId'] as int?
          : null,
    );
  }

  static PendingUsersSnapshot parsePending(Map<String, dynamic> json) {
    final amPendingUsers =
        (json['amPendingUsers'] as List<dynamic>? ?? const [])
            .map((item) => parseUser(item as Map<String, dynamic>))
            .toList();
    final pmPendingUsers =
        (json['pmPendingUsers'] as List<dynamic>? ?? const [])
            .map((item) => parseUser(item as Map<String, dynamic>))
            .toList();
    return PendingUsersSnapshot(
      workDate: json['workDate'] as String? ?? '',
      amPendingUsers: amPendingUsers,
      pmPendingUsers: pmPendingUsers,
    );
  }

  static MetricsReportSnapshot parseMetrics(Map<String, dynamic> json) {
    final users = (json['users'] as List<dynamic>? ?? const [])
        .map((item) => parseMetricsUser(item as Map<String, dynamic>))
        .toList();
    return MetricsReportSnapshot(
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      days: json['days'] as int? ?? 0,
      users: users,
    );
  }

  static MetricsUserSnapshot parseMetricsUser(Map<String, dynamic> json) {
    return MetricsUserSnapshot(
      user: parseUser(json['user'] as Map<String, dynamic>),
      amSubmitted: json['amSubmitted'] as int? ?? 0,
      expectedWorkdays: json['expectedWorkdays'] as int? ?? 0,
      pmSubmitted: json['pmSubmitted'] as int? ?? 0,
      missedAm: json['missedAm'] as int? ?? 0,
      missedPm: json['missedPm'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      warning: json['warning'] as int? ?? 0,
      blocked: json['blocked'] as int? ?? 0,
      dropped: json['dropped'] as int? ?? 0,
    );
  }

  static AdminUserRecord parseUser(Map<String, dynamic> json) {
    return AdminUserRecord(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      telegramUserId: json['telegramUserId'] as int? ?? 0,
      username: json['username'] as String?,
      joinedAt: json['joinedAt'] as String?,
    );
  }

  static WarningResult parseWarningResult(Map<String, dynamic> json) {
    return WarningResult(
      warningId: json['warningId'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      privateDeliveryFailed: json['privateDeliveryFailed'] as bool? ?? false,
    );
  }

  static GroupBindingIntentResult parseBindingIntent(
    Map<String, dynamic> json,
  ) {
    return GroupBindingIntentResult(
      token: json['token'] as String? ?? '',
      bindCommand: json['bindCommand'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
    );
  }
}

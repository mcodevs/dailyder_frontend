import 'package:equatable/equatable.dart';

class AdminOverview extends Equatable {
  const AdminOverview({
    required this.adminCount,
    required this.onboardedUserCount,
    required this.amScheduler,
    required this.pmScheduler,
    this.groupTitle,
    this.messageThreadId,
  });

  final int adminCount;
  final int onboardedUserCount;
  final String amScheduler;
  final String pmScheduler;
  final String? groupTitle;
  final int? messageThreadId;

  @override
  List<Object?> get props => [
    adminCount,
    onboardedUserCount,
    amScheduler,
    pmScheduler,
    groupTitle,
    messageThreadId,
  ];
}

class AdminUserRecord extends Equatable {
  const AdminUserRecord({
    required this.id,
    required this.displayName,
    required this.telegramUserId,
    this.username,
    this.joinedAt,
  });

  final String id;
  final String displayName;
  final int telegramUserId;
  final String? username;
  final String? joinedAt;

  @override
  List<Object?> get props => [
    id,
    displayName,
    telegramUserId,
    username,
    joinedAt,
  ];
}

class PendingUsersSnapshot extends Equatable {
  const PendingUsersSnapshot({
    required this.workDate,
    required this.amPendingUsers,
    required this.pmPendingUsers,
  });

  final String workDate;
  final List<AdminUserRecord> amPendingUsers;
  final List<AdminUserRecord> pmPendingUsers;

  @override
  List<Object?> get props => [workDate, amPendingUsers, pmPendingUsers];
}

class MetricsUserSnapshot extends Equatable {
  const MetricsUserSnapshot({
    required this.user,
    required this.amSubmitted,
    required this.expectedWorkdays,
    required this.pmSubmitted,
    required this.missedAm,
    required this.missedPm,
    required this.completed,
    required this.warning,
    required this.blocked,
    required this.dropped,
  });

  final AdminUserRecord user;
  final int amSubmitted;
  final int expectedWorkdays;
  final int pmSubmitted;
  final int missedAm;
  final int missedPm;
  final int completed;
  final int warning;
  final int blocked;
  final int dropped;

  @override
  List<Object?> get props => [
    user,
    amSubmitted,
    expectedWorkdays,
    pmSubmitted,
    missedAm,
    missedPm,
    completed,
    warning,
    blocked,
    dropped,
  ];
}

class MetricsReportSnapshot extends Equatable {
  const MetricsReportSnapshot({
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.users,
  });

  final String startDate;
  final String endDate;
  final int days;
  final List<MetricsUserSnapshot> users;

  @override
  List<Object?> get props => [startDate, endDate, days, users];
}

class WarningResult extends Equatable {
  const WarningResult({
    required this.warningId,
    required this.reason,
    required this.privateDeliveryFailed,
  });

  final String warningId;
  final String reason;
  final bool privateDeliveryFailed;

  @override
  List<Object?> get props => [warningId, reason, privateDeliveryFailed];
}

class GroupBindingIntentResult extends Equatable {
  const GroupBindingIntentResult({
    required this.token,
    required this.bindCommand,
    required this.expiresAt,
  });

  final String token;
  final String bindCommand;
  final String expiresAt;

  @override
  List<Object?> get props => [token, bindCommand, expiresAt];
}

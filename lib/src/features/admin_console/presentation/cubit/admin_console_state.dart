import 'package:equatable/equatable.dart';

import '../../../../common/data/enums/status.dart';
import '../../domain/entity/admin_console_entities.dart';

enum AdminSection {
  overview,
  pending,
  metrics,
  users,
  reminders,
  warnings,
  groupBinding,
}

class AdminConsoleState extends Equatable {
  const AdminConsoleState({
    required this.status,
    this.overview,
    this.pendingSnapshot,
    this.metricsSnapshot,
    this.users = const [],
    this.warningResult,
    this.bindingIntent,
    this.errorMessage,
    this.infoMessage,
    this.isBusy = false,
  });

  final Status status;
  final AdminOverview? overview;
  final PendingUsersSnapshot? pendingSnapshot;
  final MetricsReportSnapshot? metricsSnapshot;
  final List<AdminUserRecord> users;
  final WarningResult? warningResult;
  final GroupBindingIntentResult? bindingIntent;
  final String? errorMessage;
  final String? infoMessage;
  final bool isBusy;

  AdminConsoleState copyWith({
    Status? status,
    AdminOverview? overview,
    PendingUsersSnapshot? pendingSnapshot,
    MetricsReportSnapshot? metricsSnapshot,
    List<AdminUserRecord>? users,
    WarningResult? warningResult,
    GroupBindingIntentResult? bindingIntent,
    String? errorMessage,
    String? infoMessage,
    bool? isBusy,
  }) {
    return AdminConsoleState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      pendingSnapshot: pendingSnapshot ?? this.pendingSnapshot,
      metricsSnapshot: metricsSnapshot ?? this.metricsSnapshot,
      users: users ?? this.users,
      warningResult: warningResult ?? this.warningResult,
      bindingIntent: bindingIntent ?? this.bindingIntent,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  List<Object?> get props => [
    status,
    overview,
    pendingSnapshot,
    metricsSnapshot,
    users,
    warningResult,
    bindingIntent,
    errorMessage,
    infoMessage,
    isBusy,
  ];
}

import '../../domain/entity/session_user.dart';

class SessionUserModel {
  const SessionUserModel({
    required this.telegramUserId,
    required this.displayName,
    required this.isAdmin,
    required this.isOnboarded,
    required this.isGroupBound,
    required this.isGroupMember,
    required this.authMode,
    this.username,
  });

  final int telegramUserId;
  final String displayName;
  final bool isAdmin;
  final bool isOnboarded;
  final bool isGroupBound;
  final bool isGroupMember;
  final String authMode;
  final String? username;

  factory SessionUserModel.fromJson(Map<String, dynamic> json) {
    return SessionUserModel(
      telegramUserId: json['telegramUserId'] as int,
      displayName: json['displayName'] as String,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isOnboarded: json['isOnboarded'] as bool? ?? false,
      isGroupBound: json['isGroupBound'] as bool? ?? false,
      isGroupMember: json['isGroupMember'] as bool? ?? false,
      authMode: json['authMode'] as String? ?? 'dev',
      username: json['username'] as String?,
    );
  }

  SessionUser toEntity() {
    return SessionUser(
      telegramUserId: telegramUserId,
      displayName: displayName,
      isAdmin: isAdmin,
      isOnboarded: isOnboarded,
      isGroupBound: isGroupBound,
      isGroupMember: isGroupMember,
      authMode: authMode,
      username: username,
    );
  }
}

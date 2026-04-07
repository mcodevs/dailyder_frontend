import 'package:equatable/equatable.dart';

class SessionUser extends Equatable {
  const SessionUser({
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

  @override
  List<Object?> get props => [
    telegramUserId,
    displayName,
    isAdmin,
    isOnboarded,
    isGroupBound,
    isGroupMember,
    authMode,
    username,
  ];
}

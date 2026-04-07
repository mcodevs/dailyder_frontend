class SessionAuthResponseModel {
  const SessionAuthResponseModel({
    required this.accessToken,
    required this.expiresAt,
  });

  final String accessToken;
  final String expiresAt;

  factory SessionAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionAuthResponseModel(
      accessToken: json['accessToken'] as String,
      expiresAt: json['expiresAt'] as String,
    );
  }
}

bool isTelegramWebAppContext({
  required String initData,
  required String? platform,
}) {
  if (initData.trim().isNotEmpty) {
    return true;
  }

  final normalizedPlatform = platform?.trim().toLowerCase();
  if (normalizedPlatform == null || normalizedPlatform.isEmpty) {
    return false;
  }

  return normalizedPlatform != 'unknown';
}

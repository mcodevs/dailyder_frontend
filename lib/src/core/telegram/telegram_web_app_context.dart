bool isTelegramWebAppContext({
  required String initData,
  required String? platform,
  Uri? currentUri,
}) {
  if (initData.trim().isNotEmpty) {
    return true;
  }

  final normalizedPlatform = platform?.trim().toLowerCase();
  if (normalizedPlatform == null || normalizedPlatform.isEmpty) {
    final queryPlatform = currentUri?.queryParameters['tgWebAppPlatform']
        ?.trim()
        .toLowerCase();
    if (queryPlatform == null || queryPlatform.isEmpty) {
      return false;
    }
    return queryPlatform != 'unknown';
  }

  return normalizedPlatform != 'unknown';
}

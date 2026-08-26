/// Retorna `true` quando a sessão precisa ser renovada antes da sincronização.
///
/// O Supabase informa [expiresAt] em segundos desde o Unix epoch. Renovamos
/// também sessões próximas do vencimento para que o token não expire durante
/// um PUSH longo.
bool shouldRefreshSyncSession(
  int? expiresAt, {
  DateTime? now,
  Duration refreshWindow = const Duration(minutes: 2),
}) {
  if (expiresAt == null) return true;
  final nowSeconds =
      (now ?? DateTime.now()).toUtc().millisecondsSinceEpoch ~/ 1000;
  return expiresAt <= nowSeconds + refreshWindow.inSeconds;
}

/// Retorna `true` quando a sessão anterior já estava ausente ou expirada.
///
/// Diferente da renovação preventiva, este caso pode ter deixado dados remotos
/// fora do SQLite. Após recuperar a sessão, o sync deve fazer um PULL completo.
bool shouldForceFullPullAfterSessionRefresh(
  int? previousExpiresAt, {
  DateTime? now,
}) =>
    shouldRefreshSyncSession(
      previousExpiresAt,
      now: now,
      refreshWindow: Duration.zero,
    );

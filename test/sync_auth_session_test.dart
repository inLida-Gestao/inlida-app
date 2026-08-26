import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/backend/api_requests/api_calls.dart';
import 'package:in_lida/backend/utils/sync_auth_session.dart';

void main() {
  final now = DateTime.utc(2026, 8, 26, 12);
  final nowSeconds = now.millisecondsSinceEpoch ~/ 1000;

  group('shouldRefreshSyncSession', () {
    test('renova sessão ausente', () {
      expect(shouldRefreshSyncSession(null, now: now), isTrue);
    });

    test('renova sessão expirada', () {
      expect(
        shouldRefreshSyncSession(nowSeconds - 1, now: now),
        isTrue,
      );
    });

    test('renova sessão próxima do vencimento', () {
      expect(
        shouldRefreshSyncSession(nowSeconds + 60, now: now),
        isTrue,
      );
    });

    test('mantém sessão válida durante o próximo PUSH', () {
      expect(
        shouldRefreshSyncSession(nowSeconds + 3600, now: now),
        isFalse,
      );
    });
  });

  group('shouldForceFullPullAfterSessionRefresh', () {
    test('força PULL completo quando a sessão estava ausente', () {
      expect(
        shouldForceFullPullAfterSessionRefresh(null, now: now),
        isTrue,
      );
    });

    test('força PULL completo quando a sessão já estava expirada', () {
      expect(
        shouldForceFullPullAfterSessionRefresh(nowSeconds - 1, now: now),
        isTrue,
      );
    });

    test('não força PULL completo em renovação apenas preventiva', () {
      expect(
        shouldForceFullPullAfterSessionRefresh(nowSeconds + 60, now: now),
        isFalse,
      );
    });
  });

  group('SupabaseFunctionsGroup.setAuthToken', () {
    tearDown(() => SupabaseFunctionsGroup.setAuthToken(null));

    test('usa JWT autenticado nas RPCs de sincronização', () {
      SupabaseFunctionsGroup.setAuthToken('jwt-do-usuario');

      expect(
        SupabaseFunctionsGroup.headers['Authorization'],
        'Bearer jwt-do-usuario',
      );
    });

    test('restaura chave anônima quando a sessão é removida', () {
      final anonymousAuthorization =
          SupabaseFunctionsGroup.headers['Authorization'];
      SupabaseFunctionsGroup.setAuthToken('jwt-do-usuario');
      SupabaseFunctionsGroup.setAuthToken(null);

      expect(
        SupabaseFunctionsGroup.headers['Authorization'],
        anonymousAuthorization,
      );
    });
  });
}

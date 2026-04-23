# Arquitetura de Sincronização — Estado Atual e Roadmap

> Documento criado em B4 — referência viva para evolução do sync. Atualize
> ao fazer mudanças estruturais.

## 1. Visão geral atual (pós-correções A1–B2 + B5/B6)

### Componentes

| Camada | Arquivo | Responsabilidade |
|--------|---------|------------------|
| Conectividade | `lib/custom_code/actions/check_internet_connection.dart` | DNS lookup (`google.com`) + `pingSupabase()` (warm-up REST) |
| Listener | `lib/pages/home_page/home_page_widget.dart` (initState) | Stream de connectivity_plus → debounce 10s → warm-up → `performAutoSync` |
| Auto-sync | `lib/custom_code/actions/auto_sync.dart` | Orquestração PUSH→PULL com watchdogs por módulo (90s/120s) e timer global 3min |
| Sync manual | `lib/components/navegacao_widget.dart` | Botão refresh + watchdog 3min + long-press para diagnóstico |
| Operações | `lib/actions/actions.dart` | `putUpdt*` (PUSH) e `refresh*Otimizada` (PULL) por módulo |
| Telemetria | `actions.dart` (`SyncTelemetry`) + `lib/components/sync_diagnostic_dialog.dart` | Buffer circular em memória + UI de diagnóstico |
| Estado | `lib/app_state.dart` | `isSyncing`, `syncCancelRequested`, `lastSyncHeartbeat`, `dataDadosNaoSync*` |

### Fluxo PUSH (atual — exemplo Reprodução)

```
auto_sync / botão manual
  └── putUpdtReproducao(context)
        ├── buscarReproducaoPUT  (registros novos local)
        ├── buscarReproducaoUPDT (registros modificados local)
        ├── DEDUPE: remove de UPDT os IDs já em PUT
        ├── _buildReproducaoPayload por registro (sanitiza FKs, datas)
        └── _retry(maxAttempts=3, expBackoff)
              └── _batchUpsertSupabase
                    └── SupaFlow.client.from('reproducao').upsert(chunks de 200, onConflict: 'id_reproducao')
```

Características-chave:
- **Idempotente**: retries não duplicam (onConflict).
- **1 round-trip para 200 registros** (vs 1 por registro antes).
- **Cancel cooperativo**: `_throwIfCancelled` antes de cada chunk.
- **Timeout por chunk**: 45s; estourou → retry; esgotou retries → falha do módulo.

### Fluxo PULL

```
refresh*Otimizada
  ├── buscarPropriedades + change tracker (incremental updatedAfter)
  ├── while offset < total:
  │     ├── pageSize = await _adaptivePageSize()  // 250 mobile, 999 wifi
  │     ├── _withTimeout(buscar*Call, 45s)
  │     ├── batchInsertLocal* (sqflite, ConflictAlgorithm.replace)
  │     └── offset += pageRecords.length
  └── em erro de página: BREAK (não pula offset cegamente)
```

### Estado armazenado

| Campo | Persistência | Quando seta | Quando limpa |
|-------|--------------|-------------|--------------|
| `dataDadosNaoSyncRepro` (e variantes) | persistido | quando usuário cria/edita off-line | quando PUSH do módulo conclui sucesso |
| `isSyncing` | runtime | início de qualquer sync | finally do sync, watchdog 3min, boot home |
| `syncCancelRequested` | runtime | usuário aciona cancel | início de novo sync, boot home |
| `lastSyncHeartbeat` | runtime | a cada `_syncLog` | (nunca; só atualizada) |
| `lastAutoSync` | persistido | início do auto-sync | (nunca; usado para intervalo mínimo) |

## 2. Limitações conhecidas do design atual

1. **Sem fila persistente de operações.**
   Se o app for fechado durante PUSH, registros parcialmente enviados podem
   ficar inconsistentes — mitigado por `onConflict` upsert (re-envio é seguro)
   mas o sinal `dataDadosNaoSyncRepro` é binário (nulo ou não), não conta
   quantos faltam. Próximo sync re-envia TUDO desde a data marcada.

2. **`putUpdt*` para Rebanhos/Sanidades/Lotes ainda fazem `queryRows` para
   verificar existência antes de insert/update.**
   Isso adiciona round-trips. Alternativa: migrar para upsert também (B1
   estendido), mas requer validação de FKs e payload mapping caso-a-caso.

3. **Lógica duplicada entre `auto_sync.dart` e `navegacao_widget.dart`.**
   ~~Cada caminho tem seu próprio watchdog e fluxo PUSH→PULL.~~
   ✅ **Resolvido em B3** — `SyncEngine` (lib/custom_code/actions/sync_engine.dart)
   é o único ponto de entrada. `auto_sync.dart` removido.

4. **Sem detecção de conflitos remotos.**
   Estratégia "last write wins" via upsert. Se outro dispositivo modificar
   o mesmo registro, dados off-line sobrescrevem sem aviso.

5. **`SyncTelemetry` é só em memória.**
   Reset em rebuild do app. Útil para diagnóstico ao vivo, não para
   forensics histórica.

## 3. Roadmap de evolução

### Fase 1 — SyncEngine unificado (B3) ✅ IMPLEMENTADO

Implementação real em `lib/custom_code/actions/sync_engine.dart`:

- Singleton `SyncEngine.instance` com mutex via flag (`_active`).
- API: `run(context, {trigger, onProgress})` retornando `SyncResult`.
- Triggers: `manual`, `autoReconnect`, `boot`.
- `SyncProgress` stream para UI; watchdog global de 3min.
- Wrappers retro-compat: `performAutoSync(context)` e `performManualSync(context)`.
- Throttle automático para `autoReconnect` (mínimo 60s entre execuções).

Exemplo histórico (descartado):

```dart
class SyncEngine {
  static final SyncEngine instance = SyncEngine._();
  final _mutex = Mutex();
  final _progressController = StreamController<SyncProgress>.broadcast();

  Stream<SyncProgress> get progress => _progressController.stream;
  bool get isSyncing => _mutex.isLocked;

  Future<SyncResult> sync({SyncTrigger trigger = SyncTrigger.manual}) async {
    if (_mutex.isLocked) return SyncResult.alreadyRunning;
    return _mutex.protect(() => _runSync(trigger));
  }

  Future<void> cancel() async => FFAppState().syncCancelRequested = true;
}
```

Benefícios:
- Mutex elimina race conditions entre manual + auto.
- Stream de progresso permite UI reativa (sem polling).
- Trigger conhecido facilita decisões (ex.: pular PULL em rede móvel).

### Fase 2 — Fila persistente de operações

Substituir o sinalizador binário `dataDadosNaoSync*` por uma tabela SQLite:

```sql
CREATE TABLE sync_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  module TEXT NOT NULL,           -- 'reproducao', 'rebanho', etc
  operation TEXT NOT NULL,        -- 'upsert', 'delete'
  entity_id TEXT NOT NULL,
  payload TEXT NOT NULL,          -- JSON
  attempts INTEGER DEFAULT 0,
  last_error TEXT,
  created_at TEXT NOT NULL,
  next_retry_at TEXT
);
```

Vantagens:
- Conta exata de pendentes (UI: "3 registros para enviar").
- Retry seletivo por registro (não re-envia tudo).
- Backoff persistido (sobrevive a fechar app).
- Fácil migração: trigger SQL no `INSERT/UPDATE` das tabelas locais
  alimenta a fila.

### Fase 3 — Resolução de conflitos

- Adicionar `version` ou `last_modified_remote` em cada tabela.
- No upsert, enviar `If-Match` (PostgREST suporta).
- Em conflito, apresentar UI de merge ao usuário ou aplicar política
  (ex.: "remoto vence se for mais recente").

### Fase 4 — Telemetria persistente (B6 estendido)

Tabela SQLite `sync_log` com retenção de 7 dias. Tela de diagnóstico
filtra por flow/data/módulo. Permite suporte ao usuário enviar logs por
e-mail.

## 4. Convenções de código

- **Sempre use `_withTimeout`** para qualquer call ao Supabase. Nunca
  invoque `SupaFlow.client.from(...)` diretamente sem proteção.
- **Sempre chame `_throwIfCancelled(flow)`** no início de cada iteração
  de loop > ~1s.
- **Nunca envie `'Não'`/`'NAO'`/`''` em FK**. Use `null`. Use
  `_buildReproducaoPayload` como referência.
- **Heartbeat automático** via `_syncLog` — não precisa atualizar manualmente.
- **Para diagnóstico**, abra `SyncDiagnosticDialog.show(context)`
  (atualmente disparado por long-press no botão de sync).

/// Timestamp de concorrência enviado ao Supabase (`client_updated_at`).
///
/// CONTEXTO — POR QUE ESTE ARQUIVO EXISTE:
/// O app grava datas no SQLite como strings NAIVE em horário local
/// (`yyyy-MM-dd HH:mm:ss`, sem fuso). Para os campos de negócio isso é a
/// convenção histórica e NÃO deve ser alterada (ver /memories/repo/sync.md):
/// converter para UTC desloca +3h no Brasil e quebra os relatórios por período
/// do dashboard web.
///
/// O `client_updated_at`, porém, NÃO é uma data de negócio: é um marcador de
/// INSTANTE usado só pelo trigger `prevent_stale_rebanho_update` (migração
/// 012) para ordenar edições concorrentes. Ele precisa ser um instante UTC
/// real, com fuso explícito.
///
/// Foi exatamente a mistura desses dois conceitos que causou o bug de produção
/// de 11/08/2026: o app mandava um horário local naive, o Postgres interpretava
/// como UTC (ficando 3h "no passado") e o trigger recusava em silêncio todo
/// UPDATE de animais já sincronizados — travando 67 registros e fazendo um lote
/// de 60 animais subir com 59.
library;

/// Converte um timestamp local do SQLite em ISO-8601 UTC (sufixo `Z`).
///
/// Percorre [candidates] na ordem e usa o primeiro valor parseável. Valores
/// nulos, vazios ou com a string literal `'null'` são ignorados. Quando nenhum
/// candidato serve, usa [now] (default: `DateTime.now()`) — nunca retorna nulo,
/// porque um payload sem marcador de concorrência perde a proteção do guard.
///
/// Strings sem indicador de fuso (`2026-08-11 16:14:32`) são interpretadas como
/// horário LOCAL do dispositivo e convertidas para UTC — que é o comportamento
/// correto, já que o SQLite as gravou a partir de `DateTime.now()`. Strings que
/// já trazem fuso (`...Z` ou `...+00:00`) são normalizadas para UTC sem
/// deslocamento adicional.
String resolveClientUpdatedAtUtc(
  Iterable<Object?> candidates, {
  DateTime? now,
}) {
  for (final candidate in candidates) {
    final raw = candidate?.toString().trim();
    if (raw == null || raw.isEmpty || raw.toLowerCase() == 'null') continue;
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed.toUtc().toIso8601String();
  }
  return (now ?? DateTime.now()).toUtc().toIso8601String();
}

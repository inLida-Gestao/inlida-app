-- ============================================================================
-- MIGRATION: Preencher id_propriedade nulo em historico_pesagens
-- Projeto: inLida App
-- Data: 2026-03-28
-- Descrição: Alguns registros de historico_pesagens foram criados (via web)
--   sem o campo id_propriedade. O app mobile filtra pesagens por
--   id_propriedade, então registros com NULL são invisíveis para o app.
--   Esta migration preenche id_propriedade a partir da tabela rebanho.
-- ============================================================================

-- 1. Backfill: copiar idPropriedade do rebanho para pesagens onde está NULL
UPDATE historico_pesagens hp
SET id_propriedade = r."idPropriedade"
FROM rebanho r
WHERE hp."idRebanho" = r."idRebanho"
  AND hp.id_propriedade IS NULL
  AND r."idPropriedade" IS NOT NULL;

-- 2. (Opcional) Verificar quantos registros ainda ficaram sem id_propriedade
-- SELECT COUNT(*) AS pesagens_sem_propriedade
-- FROM historico_pesagens
-- WHERE id_propriedade IS NULL;

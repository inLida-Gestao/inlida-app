-- ============================================================================
-- MIGRATION: Deduplicar animais e bloquear duplicidade lógica no rebanho
-- Projeto: inLida App
-- Descrição:
--   - identifica animais ativos duplicados pela chave lógica
--     (idPropriedade + numeroAnimal + dataNascimento + sexo);
--   - escolhe canônico priorizando o registro com mais vínculos em módulos
--     dependentes e, em empate, o mais antigo;
--   - reatribui vínculos das duplicatas para o canônico;
--   - marca duplicatas como deletado='SIM';
--   - cria índice único parcial para impedir novas duplicidades ativas.
-- ============================================================================

BEGIN;

CREATE INDEX IF NOT EXISTS idx_rebanho_dedup_lookup
  ON rebanho (
    "idPropriedade",
    "numeroAnimal",
    (CASE
      WHEN NULLIF(NULLIF("dataNascimento"::TEXT, ''), 'null') ~ '^\d{4}-\d{2}-\d{2}'
        THEN SUBSTRING("dataNascimento"::TEXT FROM 1 FOR 10)::DATE
      ELSE DATE '0001-01-01'
    END),
    (COALESCE(sexo, ''))
  )
  WHERE COALESCE(deletado, 'NAO') != 'SIM'
    AND COALESCE("idPropriedade", '') != ''
    AND COALESCE("numeroAnimal", '') != '';

CREATE TEMP TABLE tmp_rebanho_dedup AS
WITH active_rebanho AS (
  SELECT
    r."idRebanho",
    r."idPropriedade",
    r."numeroAnimal",
    CASE
      WHEN NULLIF(NULLIF(r."dataNascimento"::TEXT, ''), 'null') ~ '^\d{4}-\d{2}-\d{2}'
        THEN SUBSTRING(r."dataNascimento"::TEXT FROM 1 FOR 10)::DATE
      ELSE DATE '0001-01-01'
    END AS data_nascimento_key,
    COALESCE(r.sexo, '') AS sexo_key,
    COALESCE(r.created_at, r.updated_at, TIMESTAMPTZ '1970-01-01') AS created_sort,
    COALESCE(r.updated_at, r.created_at, TIMESTAMPTZ '1970-01-01') AS updated_sort,
    (
      SELECT COUNT(*) FROM historico_pesagens hp
      WHERE hp."idRebanho" = r."idRebanho"
    ) +
    (
      SELECT COUNT(*) FROM sanidade s
      WHERE s.id_rebanho = r."idRebanho"
    ) +
    (
      SELECT COUNT(*) FROM reproducao rp
      WHERE rp.id_rebanho_matriz = r."idRebanho"
         OR rp.id_rebanho_reprodutor = r."idRebanho"
    ) AS ref_count
  FROM rebanho r
  WHERE COALESCE(r.deletado, 'NAO') != 'SIM'
    AND COALESCE(r."idPropriedade", '') != ''
    AND COALESCE(r."numeroAnimal", '') != ''
),
ranked AS (
  SELECT
    ar.*,
    COUNT(*) OVER (
      PARTITION BY
        ar."idPropriedade",
        ar."numeroAnimal",
        ar.data_nascimento_key,
        ar.sexo_key
    ) AS group_count,
    FIRST_VALUE(ar."idRebanho") OVER (
      PARTITION BY
        ar."idPropriedade",
        ar."numeroAnimal",
        ar.data_nascimento_key,
        ar.sexo_key
      ORDER BY
        ar.ref_count DESC,
        ar.created_sort ASC,
        ar.updated_sort ASC,
        ar."idRebanho" ASC
    ) AS canonical_id
  FROM active_rebanho ar
)
SELECT
  "idRebanho" AS duplicate_id,
  canonical_id
FROM ranked
WHERE group_count > 1
  AND "idRebanho" <> canonical_id;

UPDATE historico_pesagens hp
SET "idRebanho" = d.canonical_id
FROM tmp_rebanho_dedup d
WHERE hp."idRebanho" = d.duplicate_id;

UPDATE sanidade s
SET id_rebanho = d.canonical_id,
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE s.id_rebanho = d.duplicate_id;

UPDATE reproducao rp
SET id_rebanho_matriz = d.canonical_id,
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE rp.id_rebanho_matriz = d.duplicate_id;

UPDATE reproducao rp
SET id_rebanho_reprodutor = d.canonical_id,
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE rp.id_rebanho_reprodutor = d.duplicate_id;

UPDATE rebanho r
SET "rebanhoIdMatriz" = d.canonical_id,
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE r."rebanhoIdMatriz" = d.duplicate_id;

UPDATE rebanho r
SET "rebanhoIdReprodutor" = d.canonical_id,
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE r."rebanhoIdReprodutor" = d.duplicate_id;

UPDATE lotes l
SET id_animais = REPLACE(id_animais, d.duplicate_id, d.canonical_id),
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE l.id_animais LIKE '%' || d.duplicate_id || '%';

UPDATE rebanho r
SET deletado = 'SIM',
    updated_at = NOW()
FROM tmp_rebanho_dedup d
WHERE r."idRebanho" = d.duplicate_id;

DROP TABLE tmp_rebanho_dedup;

DROP INDEX IF EXISTS idx_rebanho_active_logical_unique;
CREATE UNIQUE INDEX idx_rebanho_active_logical_unique
  ON rebanho (
    "idPropriedade",
    "numeroAnimal",
    (CASE
      WHEN NULLIF(NULLIF("dataNascimento"::TEXT, ''), 'null') ~ '^\d{4}-\d{2}-\d{2}'
        THEN SUBSTRING("dataNascimento"::TEXT FROM 1 FOR 10)::DATE
      ELSE DATE '0001-01-01'
    END),
    (COALESCE(sexo, ''))
  )
  WHERE COALESCE(deletado, 'NAO') != 'SIM'
    AND COALESCE("idPropriedade", '') != ''
    AND COALESCE("numeroAnimal", '') != '';

COMMIT;

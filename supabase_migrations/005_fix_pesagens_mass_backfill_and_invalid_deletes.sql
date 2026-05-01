-- ============================================================================
-- MIGRATION: Corrigir gargalo de pesagens causado por backfill em massa
-- Projeto: inLida App
-- Descrição:
--   - remove linhas inválidas criadas por upsert legado de delete usando id local;
--   - redefine a RPC keyset para ignorar o updated_at artificial gerado pelo
--     backfill de id_pesagem/id_propriedade em 2026-04-30 20:30-20:40 UTC;
--   - limita o PULL mobile a pesagens ativas, evitando baixar centenas de
--     milhares de soft-deletes legados no estágio 85%;
--   - filtra linhas sem identidade mínima de pesagem.
-- ============================================================================

DELETE FROM historico_pesagens
WHERE deletado = 'SIM'
  AND id_propriedade IS NULL
  AND "idRebanho" IS NULL
  AND "dataPesagem" IS NULL
  AND tipo IS NULL
  AND peso IS NULL;

CREATE OR REPLACE FUNCTION historico_pesagens_mobile_defaults()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT'
    AND NEW.deletado = 'SIM'
    AND NEW.id_propriedade IS NULL
    AND NEW."idRebanho" IS NULL
    AND NEW."dataPesagem" IS NULL
    AND NEW.tipo IS NULL
    AND NEW.peso IS NULL
  THEN
    RAISE EXCEPTION
      'historico_pesagens: recusado INSERT deletado=SIM sem dados de pesagem';
  END IF;

  IF COALESCE(BTRIM(NEW.id_pesagem), '') = '' THEN
    NEW.id_pesagem := 'legacy_remote:' || COALESCE(
      NEW.id::TEXT,
      MD5(
        COALESCE(NEW."idRebanho"::TEXT, '') || '|' ||
        COALESCE(NEW."dataPesagem"::TEXT, '') || '|' ||
        COALESCE(NEW.tipo::TEXT, '') || '|' ||
        COALESCE(NEW.peso::TEXT, '') || '|' ||
        COALESCE(NEW.created_at::TEXT, '')
      )
    );
  END IF;

  IF NEW.id_propriedade IS NULL AND NEW."idRebanho" IS NOT NULL THEN
    SELECT r."idPropriedade"
    INTO NEW.id_propriedade
    FROM rebanho r
    WHERE r."idRebanho" = NEW."idRebanho"
    LIMIT 1;
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION historico_pesagens_mobile_keyset(
  p_property_ids TEXT[],
  p_limit INT DEFAULT 999,
  p_updated_after TIMESTAMPTZ DEFAULT NULL,
  p_cursor_updated_at TIMESTAMPTZ DEFAULT NULL,
  p_cursor_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  id BIGINT,
  id_pesagem TEXT,
  "idRebanho" TEXT,
  "dataPesagem" TEXT,
  tipo TEXT,
  peso NUMERIC,
  deletado TEXT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ,
  id_propriedade TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH eligible AS (
    SELECT
      hp.*,
      CASE
        -- Backfill da migration 004 tocou centenas de milhares de linhas e
        -- acionou o trigger set_updated_at_pesagens. Para sync mobile, esse
        -- updated_at não representa alteração de negócio; usar created_at evita
        -- rebaixar toda a tabela no 85%.
        WHEN hp.id_pesagem LIKE 'legacy_remote:%'
          AND hp.updated_at >= TIMESTAMPTZ '2026-04-30 20:30:00+00'
          AND hp.updated_at <  TIMESTAMPTZ '2026-04-30 20:40:00+00'
          AND hp.created_at < TIMESTAMPTZ '2026-04-30 20:00:00+00'
        THEN hp.created_at
        ELSE COALESCE(hp.updated_at, hp.created_at)
      END AS sync_updated_at
    FROM historico_pesagens hp
    WHERE hp.id_propriedade = ANY(p_property_ids)
      AND COALESCE(hp.deletado, 'NAO') != 'SIM'
      AND hp."idRebanho" IS NOT NULL
      AND hp."dataPesagem" IS NOT NULL
      AND hp.tipo IS NOT NULL
      AND hp.peso IS NOT NULL
  )
  SELECT
    e.id::BIGINT,
    e.id_pesagem,
    e."idRebanho"::TEXT,
    e."dataPesagem"::TEXT,
    e.tipo::TEXT,
    e.peso::NUMERIC,
    e.deletado::TEXT,
    e.created_at::TIMESTAMPTZ,
    e.sync_updated_at::TIMESTAMPTZ AS updated_at,
    e.id_propriedade::TEXT
  FROM eligible e
  WHERE (
      p_updated_after IS NULL
      OR e.sync_updated_at > p_updated_after
    )
    AND (
      p_cursor_updated_at IS NULL
      OR (
        e.sync_updated_at,
        e.id::BIGINT
      ) > (
        p_cursor_updated_at,
        COALESCE(p_cursor_id, 0)
      )
    )
  ORDER BY e.sync_updated_at ASC, e.id ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 1000);
$$;

GRANT EXECUTE ON FUNCTION historico_pesagens_mobile_keyset(
  TEXT[],
  INT,
  TIMESTAMPTZ,
  TIMESTAMPTZ,
  BIGINT
) TO authenticated;
GRANT EXECUTE ON FUNCTION historico_pesagens_mobile_keyset(
  TEXT[],
  INT,
  TIMESTAMPTZ,
  TIMESTAMPTZ,
  BIGINT
) TO anon;

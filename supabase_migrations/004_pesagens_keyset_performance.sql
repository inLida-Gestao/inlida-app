-- ============================================================================
-- MIGRATION: Chave estável e keyset pagination para historico_pesagens
-- Projeto: inLida App
-- Descrição:
--   - adiciona id_pesagem para upsert idempotente do mobile;
--   - preenche id_propriedade em registros legados;
--   - cria índices para o estágio 85% da sincronização;
--   - cria RPC keyset sem OFFSET para baixar pesagens.
-- ============================================================================

ALTER TABLE historico_pesagens
  ADD COLUMN IF NOT EXISTS id_pesagem TEXT;

-- Backfill determinístico para registros remotos já existentes.
-- O app usa o mesmo fallback "legacy_remote:<id>" quando encontra linhas antigas
-- sem id_pesagem antes desta migration estar aplicada.
UPDATE historico_pesagens
SET id_pesagem = 'legacy_remote:' || id::TEXT
WHERE COALESCE(BTRIM(id_pesagem), '') = '';

-- Preencher id_propriedade legado a partir do rebanho.
UPDATE historico_pesagens hp
SET id_propriedade = r."idPropriedade"
FROM rebanho r
WHERE hp."idRebanho" = r."idRebanho"
  AND hp.id_propriedade IS NULL
  AND r."idPropriedade" IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS historico_pesagens_id_pesagem_key
  ON historico_pesagens (id_pesagem);

CREATE INDEX IF NOT EXISTS historico_pesagens_prop_updated_id_idx
  ON historico_pesagens (id_propriedade, updated_at, id);

CREATE INDEX IF NOT EXISTS historico_pesagens_prop_id_idx
  ON historico_pesagens (id_propriedade, id);

CREATE INDEX IF NOT EXISTS historico_pesagens_rebanho_null_prop_idx
  ON historico_pesagens ("idRebanho", updated_at, id)
  WHERE id_propriedade IS NULL;

CREATE OR REPLACE FUNCTION historico_pesagens_mobile_defaults()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
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

DROP TRIGGER IF EXISTS set_mobile_defaults_historico_pesagens
  ON historico_pesagens;

CREATE TRIGGER set_mobile_defaults_historico_pesagens
  BEFORE INSERT OR UPDATE OF "idRebanho", id_propriedade, id_pesagem
  ON historico_pesagens
  FOR EACH ROW
  EXECUTE FUNCTION historico_pesagens_mobile_defaults();

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
  SELECT
    hp.id::BIGINT,
    hp.id_pesagem,
    hp."idRebanho"::TEXT,
    hp."dataPesagem"::TEXT,
    hp.tipo::TEXT,
    hp.peso::NUMERIC,
    hp.deletado::TEXT,
    hp.created_at::TIMESTAMPTZ,
    COALESCE(hp.updated_at, hp.created_at)::TIMESTAMPTZ AS updated_at,
    hp.id_propriedade::TEXT
  FROM historico_pesagens hp
  WHERE hp.id_propriedade = ANY(p_property_ids)
    AND (
      p_updated_after IS NULL
      OR COALESCE(hp.updated_at, hp.created_at) > p_updated_after
    )
    AND (
      p_cursor_updated_at IS NULL
      OR (
        COALESCE(hp.updated_at, hp.created_at),
        hp.id::BIGINT
      ) > (
        p_cursor_updated_at,
        COALESCE(p_cursor_id, 0)
      )
    )
  ORDER BY COALESCE(hp.updated_at, hp.created_at) ASC, hp.id ASC
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

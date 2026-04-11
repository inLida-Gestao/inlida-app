-- ============================================================================
-- MIGRATION: Criar RPCs incrementais para sincronização otimizada
-- Projeto: inLida App
-- Data: 2026-03-24
-- Descrição: Cria versões _inc das RPCs existentes que aceitam um parâmetro
--            p_updated_after para retornar apenas registros modificados após
--            determinado timestamp, permitindo sync incremental.
-- ============================================================================

-- ============================================================================
-- PRÉ-REQUISITO: Garantir que a coluna updated_at existe nas tabelas
-- e tem um trigger para auto-update
-- ============================================================================

-- Função genérica para auto-update de updated_at
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger nas tabelas que precisam (IF NOT EXISTS via DO block)
DO $$
BEGIN
  -- rebanho
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_rebanho'
  ) THEN
    CREATE TRIGGER set_updated_at_rebanho
      BEFORE UPDATE ON rebanho
      FOR EACH ROW
      EXECUTE FUNCTION trigger_set_updated_at();
  END IF;

  -- reproducao
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_reproducao'
  ) THEN
    CREATE TRIGGER set_updated_at_reproducao
      BEFORE UPDATE ON reproducao
      FOR EACH ROW
      EXECUTE FUNCTION trigger_set_updated_at();
  END IF;

  -- sanidade
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_sanidade'
  ) THEN
    CREATE TRIGGER set_updated_at_sanidade
      BEFORE UPDATE ON sanidade
      FOR EACH ROW
      EXECUTE FUNCTION trigger_set_updated_at();
  END IF;

  -- propriedades
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_propriedades'
  ) THEN
    CREATE TRIGGER set_updated_at_propriedades
      BEFORE UPDATE ON propriedades
      FOR EACH ROW
      EXECUTE FUNCTION trigger_set_updated_at();
  END IF;

  -- historico_pesagens
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_pesagens'
  ) THEN
    CREATE TRIGGER set_updated_at_pesagens
      BEFORE UPDATE ON historico_pesagens
      FOR EACH ROW
      EXECUTE FUNCTION trigger_set_updated_at();
  END IF;

  -- lotes
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_lotes'
  ) THEN
    CREATE TRIGGER set_updated_at_lotes
      BEFORE UPDATE ON lotes
      FOR EACH ROW
      EXECUTE FUNCTION trigger_set_updated_at();
  END IF;
END;
$$;


-- ============================================================================
-- 1. propriedades_by_user_inc
-- Original: propriedades_by_user(p_user_id uuid)
-- Adiciona filtro por updated_at para sync incremental
-- ============================================================================
CREATE OR REPLACE FUNCTION propriedades_by_user_inc(
  p_user_id TEXT,
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS SETOF propriedades
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT p.*
  FROM propriedades p
  INNER JOIN users_propriedades up
    ON p."idPropriedade" = up."idPropriedade"
  WHERE up.user_id = p_user_id
    AND p_user_id = auth.uid()::TEXT
    AND up.deletado = 'NAO'
    AND p.deletado = 'NAO'
    AND p.updated_at > p_updated_after
  ORDER BY p.updated_at DESC;
$$;

-- Permissão para usuários autenticados e anon
GRANT EXECUTE ON FUNCTION propriedades_by_user_inc(TEXT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION propriedades_by_user_inc(TEXT, TIMESTAMPTZ) TO anon;


-- ============================================================================
-- 2. rebanho_propriedade_mobile_inc
-- Original: rebanho_propriedade_mobile(p_id_propriedade uuid[], p_limite int, p_offset int)
-- Adiciona filtro por updated_at para sync incremental
-- ============================================================================
CREATE OR REPLACE FUNCTION rebanho_propriedade_mobile_inc(
  p_id_propriedade TEXT[],
  p_limite INT DEFAULT 999,
  p_offset INT DEFAULT 0,
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS SETOF rebanho
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT *
  FROM rebanho
  WHERE "idPropriedade" = ANY(p_id_propriedade)
    AND updated_at > p_updated_after
  ORDER BY updated_at DESC
  LIMIT p_limite
  OFFSET p_offset;
$$;

GRANT EXECUTE ON FUNCTION rebanho_propriedade_mobile_inc(TEXT[], INT, INT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION rebanho_propriedade_mobile_inc(TEXT[], INT, INT, TIMESTAMPTZ) TO anon;


-- ============================================================================
-- 3. reproducao_mobile_inc
-- Original: reproducao_mobile(p_id_propriedade uuid[], p_limite int, p_offset int)
-- Adiciona filtro por updated_at para sync incremental
-- ============================================================================
CREATE OR REPLACE FUNCTION reproducao_mobile_inc(
  p_id_propriedade TEXT[],
  p_limite INT DEFAULT 999,
  p_offset INT DEFAULT 0,
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS SETOF reproducao
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT *
  FROM reproducao
  WHERE id_propriedade = ANY(p_id_propriedade)
    AND updated_at > p_updated_after
  ORDER BY updated_at DESC
  LIMIT p_limite
  OFFSET p_offset;
$$;

GRANT EXECUTE ON FUNCTION reproducao_mobile_inc(TEXT[], INT, INT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION reproducao_mobile_inc(TEXT[], INT, INT, TIMESTAMPTZ) TO anon;


-- ============================================================================
-- 4. sanidade_mobile_inc
-- Original: sanidade_mobile(p_id_propriedade uuid[], p_limite int, p_offset int)
-- Adiciona filtro por updated_at para sync incremental
-- ============================================================================
CREATE OR REPLACE FUNCTION sanidade_mobile_inc(
  p_id_propriedade TEXT[],
  p_limite INT DEFAULT 999,
  p_offset INT DEFAULT 0,
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS SETOF sanidade
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT *
  FROM sanidade
  WHERE id_propriedade = ANY(p_id_propriedade)
    AND updated_at > p_updated_after
  ORDER BY updated_at DESC
  LIMIT p_limite
  OFFSET p_offset;
$$;

GRANT EXECUTE ON FUNCTION sanidade_mobile_inc(TEXT[], INT, INT, TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION sanidade_mobile_inc(TEXT[], INT, INT, TIMESTAMPTZ) TO anon;


-- ============================================================================
-- 5. contar_rebanho_prop_mob_inc
-- Original: contar_rebanho_prop_mob(p_ids_propriedades uuid[])
-- Retorna a contagem de rebanhos modificados após p_updated_after
-- ============================================================================
CREATE OR REPLACE FUNCTION contar_rebanho_prop_mob_inc(
  p_ids_propriedades TEXT[],
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS BIGINT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT COUNT(*)
  FROM rebanho
  WHERE "idPropriedade" = ANY(p_ids_propriedades)
    AND updated_at > p_updated_after;
$$;

GRANT EXECUTE ON FUNCTION contar_rebanho_prop_mob_inc(TEXT[], TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION contar_rebanho_prop_mob_inc(TEXT[], TIMESTAMPTZ) TO anon;


-- ============================================================================
-- 6. contar_reproducao_prop_mob_inc
-- Original: contar_repro_prop_mob(p_ids_propriedades uuid[])
-- Retorna a contagem de reproduções modificadas após p_updated_after
-- ============================================================================
CREATE OR REPLACE FUNCTION contar_reproducao_prop_mob_inc(
  p_ids_propriedades TEXT[],
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS BIGINT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT COUNT(*)
  FROM reproducao
  WHERE id_propriedade = ANY(p_ids_propriedades)
    AND updated_at > p_updated_after;
$$;

GRANT EXECUTE ON FUNCTION contar_reproducao_prop_mob_inc(TEXT[], TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION contar_reproducao_prop_mob_inc(TEXT[], TIMESTAMPTZ) TO anon;


-- ============================================================================
-- 7. contar_sanidade_prop_mob_inc
-- Original: contar_sanidade_prop_mob(p_ids_propriedades uuid[])
-- Retorna a contagem de sanidades modificadas após p_updated_after
-- ============================================================================
CREATE OR REPLACE FUNCTION contar_sanidade_prop_mob_inc(
  p_ids_propriedades TEXT[],
  p_updated_after TIMESTAMPTZ DEFAULT '1970-01-01T00:00:00Z'
)
RETURNS BIGINT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT COUNT(*)
  FROM sanidade
  WHERE id_propriedade = ANY(p_ids_propriedades)
    AND updated_at > p_updated_after;
$$;

GRANT EXECUTE ON FUNCTION contar_sanidade_prop_mob_inc(TEXT[], TIMESTAMPTZ) TO authenticated;
GRANT EXECUTE ON FUNCTION contar_sanidade_prop_mob_inc(TEXT[], TIMESTAMPTZ) TO anon;


-- ============================================================================
-- VERIFICAÇÃO: Listar as funções criadas
-- ============================================================================
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN (
    'propriedades_by_user_inc',
    'rebanho_propriedade_mobile_inc',
    'reproducao_mobile_inc',
    'sanidade_mobile_inc',
    'contar_rebanho_prop_mob_inc',
    'contar_reproducao_prop_mob_inc',
    'contar_sanidade_prop_mob_inc'
  )
ORDER BY routine_name;

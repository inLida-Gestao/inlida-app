-- ============================================================================
-- MIGRATION: Corrigir conflito de overload nas RPCs incrementais
-- Data: 2026-04-10
-- Descrição: Remove versões duplicadas das funções _inc que usam TIMESTAMP
--            (sem timezone), mantendo apenas as versões com TIMESTAMPTZ.
--            O erro PGRST203 ocorre quando PostgREST não consegue resolver
--            qual overload usar entre TIMESTAMP e TIMESTAMPTZ.
-- ============================================================================

-- Remover overloads com TIMESTAMP (sem timezone) que conflitam
DO $$
BEGIN
  -- contar_rebanho_prop_mob_inc
  BEGIN
    DROP FUNCTION IF EXISTS contar_rebanho_prop_mob_inc(TEXT[], TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'contar_rebanho_prop_mob_inc(TIMESTAMP) não existe ou já foi removida';
  END;

  -- contar_reproducao_prop_mob_inc
  BEGIN
    DROP FUNCTION IF EXISTS contar_reproducao_prop_mob_inc(TEXT[], TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'contar_reproducao_prop_mob_inc(TIMESTAMP) não existe ou já foi removida';
  END;

  -- contar_sanidade_prop_mob_inc
  BEGIN
    DROP FUNCTION IF EXISTS contar_sanidade_prop_mob_inc(TEXT[], TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'contar_sanidade_prop_mob_inc(TIMESTAMP) não existe ou já foi removida';
  END;

  -- rebanho_propriedade_mobile_inc
  BEGIN
    DROP FUNCTION IF EXISTS rebanho_propriedade_mobile_inc(TEXT[], INT, INT, TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'rebanho_propriedade_mobile_inc(TIMESTAMP) não existe ou já foi removida';
  END;

  -- reproducao_mobile_inc
  BEGIN
    DROP FUNCTION IF EXISTS reproducao_mobile_inc(TEXT[], INT, INT, TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'reproducao_mobile_inc(TIMESTAMP) não existe ou já foi removida';
  END;

  -- sanidade_mobile_inc
  BEGIN
    DROP FUNCTION IF EXISTS sanidade_mobile_inc(TEXT[], INT, INT, TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'sanidade_mobile_inc(TIMESTAMP) não existe ou já foi removida';
  END;

  -- propriedades_by_user_inc
  BEGIN
    DROP FUNCTION IF EXISTS propriedades_by_user_inc(TEXT, TIMESTAMP);
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'propriedades_by_user_inc(TIMESTAMP) não existe ou já foi removida';
  END;
END;
$$;

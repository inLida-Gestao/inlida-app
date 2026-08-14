-- VERIFICAÇÃO — NÃO É MIGRAÇÃO. NÃO ALTERA DADOS.
--
-- Roda tudo dentro de uma transação e termina com ROLLBACK: nenhuma linha é
-- modificada de verdade. Serve para provar, contra os dados REAIS de produção,
-- que a migração 012 se comporta como esperado ANTES de distribuir o app novo.
--
-- Como usar: cole o arquivo INTEIRO no SQL Editor do Supabase e execute.
-- Depois leia a aba de mensagens/NOTICE. O último NOTICE diz APROVADO ou
-- REPROVADO. Se qualquer cenário falhar, NÃO distribua o APK.
--
-- Cenários cobertos:
--   1. App ANTIGO (2.5.1-) que NÃO envia client_updated_at  -> deve PASSAR
--      (garante que quem não atualizar o app não fica travado)
--   2. App ANTIGO mandando updated_at naive 3h atrasado      -> deve PASSAR
--      (era exatamente isso que travava os 67 registros)
--   3. App NOVO (2.5.2+) com client_updated_at atual         -> deve PASSAR
--   4. App NOVO com client_updated_at genuinamente antigo    -> deve BLOQUEAR
--      (prova que o guard de concorrência continua protegendo de verdade)
--   5. Cobertura do backfill: nenhuma linha com client_updated_at nulo

BEGIN;

DO $$
DECLARE
  v_id                text;
  v_client_before     timestamptz;
  v_updated_before    timestamptz;
  v_client_after      timestamptz;
  v_updated_after     timestamptz;
  v_sem_backfill      bigint;
  v_falhas            int := 0;
BEGIN
  -- Escolhe um animal real recém-sincronizado como cobaia.
  SELECT "idRebanho", client_updated_at, updated_at
    INTO v_id, v_client_before, v_updated_before
  FROM rebanho
  WHERE client_updated_at IS NOT NULL
  ORDER BY updated_at DESC NULLS LAST
  LIMIT 1;

  IF v_id IS NULL THEN
    RAISE EXCEPTION
      'Nenhuma linha com client_updated_at. A migração 012 foi aplicada?';
  END IF;

  RAISE NOTICE '=== Animal usado no teste: % ===', v_id;
  RAISE NOTICE 'client_updated_at atual: %', v_client_before;
  RAISE NOTICE 'updated_at atual: %', v_updated_before;
  RAISE NOTICE '---';

  ----------------------------------------------------------------------------
  -- CENÁRIO 1 — App ANTIGO: UPDATE sem tocar em client_updated_at
  ----------------------------------------------------------------------------
  BEGIN
    UPDATE rebanho
    SET "numeroAnimal" = "numeroAnimal"
    WHERE "idRebanho" = v_id;

    SELECT client_updated_at INTO v_client_after
    FROM rebanho WHERE "idRebanho" = v_id;

    IF v_client_after IS DISTINCT FROM v_client_before THEN
      RAISE NOTICE 'FALHA (1): client_updated_at mudou sozinho (% -> %)',
        v_client_before, v_client_after;
      v_falhas := v_falhas + 1;
    ELSE
      RAISE NOTICE 'OK (1): app ANTIGO consegue atualizar e o marcador é preservado.';
    END IF;
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FALHA (1): app ANTIGO foi BLOQUEADO -> % (SQLSTATE %)',
      SQLERRM, SQLSTATE;
    v_falhas := v_falhas + 1;
  END;

  ----------------------------------------------------------------------------
  -- CENÁRIO 2 — App ANTIGO mandando updated_at naive 3h atrasado (o bug)
  ----------------------------------------------------------------------------
  BEGIN
    UPDATE rebanho
    SET updated_at = (now() AT TIME ZONE 'America/Sao_Paulo')
    WHERE "idRebanho" = v_id;

    SELECT updated_at INTO v_updated_after
    FROM rebanho WHERE "idRebanho" = v_id;

    RAISE NOTICE 'OK (2): updated_at atrasado NÃO bloqueia mais. Servidor gravou: %',
      v_updated_after;
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FALHA (2): updated_at atrasado ainda bloqueia -> % (SQLSTATE %)',
      SQLERRM, SQLSTATE;
    v_falhas := v_falhas + 1;
  END;

  ----------------------------------------------------------------------------
  -- CENÁRIO 3 — App NOVO: client_updated_at atual deve passar
  ----------------------------------------------------------------------------
  BEGIN
    UPDATE rebanho
    SET client_updated_at = now()
    WHERE "idRebanho" = v_id;

    RAISE NOTICE 'OK (3): app NOVO com client_updated_at atual foi aceito.';
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FALHA (3): app NOVO foi bloqueado -> % (SQLSTATE %)',
      SQLERRM, SQLSTATE;
    v_falhas := v_falhas + 1;
  END;

  ----------------------------------------------------------------------------
  -- CENÁRIO 4 — Guard ainda protege: client_updated_at antigo deve bloquear
  ----------------------------------------------------------------------------
  BEGIN
    UPDATE rebanho
    SET client_updated_at = now() - interval '30 days'
    WHERE "idRebanho" = v_id;

    RAISE NOTICE 'FALHA (4): edição antiga NÃO foi bloqueada — guard inoperante!';
    v_falhas := v_falhas + 1;
  EXCEPTION
    WHEN sqlstate '55006' THEN
      RAISE NOTICE 'OK (4): guard bloqueou edição antiga com o código 55006 esperado.';
    WHEN OTHERS THEN
      RAISE NOTICE 'FALHA (4): bloqueou com código errado -> % (SQLSTATE %)',
        SQLERRM, SQLSTATE;
      v_falhas := v_falhas + 1;
  END;

  ----------------------------------------------------------------------------
  -- CENÁRIO 5 — Backfill cobriu todas as linhas
  ----------------------------------------------------------------------------
  SELECT count(*) INTO v_sem_backfill
  FROM rebanho
  WHERE client_updated_at IS NULL;

  IF v_sem_backfill > 0 THEN
    RAISE NOTICE 'FALHA (5): % linha(s) sem client_updated_at (backfill incompleto).',
      v_sem_backfill;
    v_falhas := v_falhas + 1;
  ELSE
    RAISE NOTICE 'OK (5): todas as linhas de rebanho têm client_updated_at.';
  END IF;

  RAISE NOTICE '---';
  IF v_falhas = 0 THEN
    RAISE NOTICE 'RESULTADO: APROVADO — seguro distribuir o app 2.5.2.';
  ELSE
    RAISE NOTICE 'RESULTADO: REPROVADO — % cenário(s) falharam. NÃO distribua.',
      v_falhas;
  END IF;
END $$;

ROLLBACK;

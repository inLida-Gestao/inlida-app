-- Corrige o deadlock de fuso horário entre o app e o guard de stale update.
--
-- Problema: `set_updated_at_rebanho` (001) grava updated_at = NOW() (UTC real)
-- a cada UPDATE bem-sucedido. O app envia updated_at como string NAIVE em
-- horário local (BRT = UTC-3) — convenção usada em todo o histórico de sync
-- para não quebrar os gráficos por período do dashboard web. O Postgres
-- interpreta essa string naive como UTC, então o valor chega ~3h atrás do
-- relógio real. O guard `prevent_stale_rebanho_update` (007/011) então vê
-- NEW.updated_at < OLD.updated_at e devolve NULL silenciosamente — o UPDATE
-- não falha, mas também não aplica, e o app não tem como saber o motivo.
--
-- Solução: uma coluna dedicada `client_updated_at` (timestamptz), sempre
-- enviada pelo app em UTC real (com offset), usada exclusivamente pelo guard
-- de concorrência. `updated_at` continua sendo gerido pelo trigger `001`
-- para não afetar os relatórios existentes.

ALTER TABLE rebanho ADD COLUMN IF NOT EXISTS client_updated_at timestamptz;

UPDATE rebanho
SET client_updated_at = COALESCE(updated_at, created_at, now())
WHERE client_updated_at IS NULL;

CREATE OR REPLACE FUNCTION prevent_stale_rebanho_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.client_updated_at IS NOT NULL
    AND OLD.client_updated_at IS NOT NULL
    AND NEW.client_updated_at < OLD.client_updated_at THEN
    RAISE EXCEPTION
      'STALE_REBANHO_UPDATE idRebanho=%, incoming client_updated_at=%, current client_updated_at=%',
      OLD."idRebanho",
      NEW.client_updated_at,
      OLD.client_updated_at
      USING ERRCODE = '55006';
  END IF;

  -- Sem client_updated_at (ex.: UPDATE legado sem o campo), mantém o valor
  -- anterior para não perder o marcador de concorrência.
  IF NEW.client_updated_at IS NULL THEN
    NEW.client_updated_at := OLD.client_updated_at;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS prevent_stale_rebanho_update ON rebanho;

CREATE TRIGGER prevent_stale_rebanho_update
  BEFORE UPDATE ON rebanho
  FOR EACH ROW
  EXECUTE FUNCTION prevent_stale_rebanho_update();

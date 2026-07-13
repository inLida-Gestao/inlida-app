-- Prevent stale mobile sync payloads from overwriting newer rebanho state.
--
-- Mobile clients send the local row updated_at in rebanho updates. If a device
-- has an old dirty row, it must not overwrite a newer server row (especially
-- loteID/loteNome). The trigger name sorts before set_updated_at_rebanho, so it
-- sees the client-supplied NEW.updated_at before moddatetime changes it.

CREATE OR REPLACE FUNCTION prevent_stale_rebanho_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.updated_at IS NOT NULL
     AND OLD.updated_at IS NOT NULLa
     AND NEW.updated_at < OLD.updated_at THEN
    RAISE LOG
      'Skipping stale rebanho update for idRebanho=%, incoming updated_at=%, current updated_at=%',
      OLD."idRebanho",
      NEW.updated_at,
      OLD.updated_at;
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS prevent_stale_rebanho_update ON rebanho;

CREATE TRIGGER prevent_stale_rebanho_update
  BEFORE UPDATE ON rebanho
  FOR EACH ROW
  EXECUTE FUNCTION prevent_stale_rebanho_update();

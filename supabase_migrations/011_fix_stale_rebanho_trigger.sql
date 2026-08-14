-- Recreate the stale-update guard for databases where migration 007 was
-- already recorded or could not be replayed after its syntax error.

CREATE OR REPLACE FUNCTION prevent_stale_rebanho_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.updated_at IS NOT NULL
    AND OLD.updated_at IS NOT NULL
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

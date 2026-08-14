-- Normaliza o contrato de parto confirmado para SIM/NAO.
-- Uma data de parto valida e evidencia de parto confirmado em registros legados.
BEGIN;

UPDATE public.reproducao
SET parida = CASE
  WHEN lower(btrim(coalesce(parida, ''))) IN ('sim', 's', 'yes', 'true')
    OR data_parto IS NOT NULL
    THEN 'SIM'
  ELSE 'NAO'
END
WHERE parida IS DISTINCT FROM CASE
  WHEN lower(btrim(coalesce(parida, ''))) IN ('sim', 's', 'yes', 'true')
    OR data_parto IS NOT NULL
    THEN 'SIM'
  ELSE 'NAO'
END;

COMMIT;
-- A previsão de parto só é válida para reproduções ainda não diagnosticadas
-- ou com prenhez confirmada. Status nulo/vazio é mantido por compatibilidade
-- e tratado pelo aplicativo como "Não diagnosticado".
BEGIN;

UPDATE public.reproducao
SET previsao_parto = NULL
WHERE previsao_parto IS NOT NULL
  AND status_reproducao IS NOT NULL
  AND btrim(status_reproducao) <> ''
  AND btrim(status_reproducao) NOT IN ('Não diagnosticado', 'Prenhez');

COMMIT;

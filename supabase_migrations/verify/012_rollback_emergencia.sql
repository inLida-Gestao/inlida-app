-- ROLLBACK DE EMERGÊNCIA — use só se o app 2.5.2 causar erros em produção.
--
-- Por que isso existe: depois que um APK é distribuído, não dá para "desfazer"
-- a instalação nos aparelhos dos usuários. Este script neutraliza o guard de
-- concorrência pelo lado do BANCO, que é reversível em segundos e atinge todo
-- mundo de uma vez — app novo e app antigo.
--
-- Efeito: o UPDATE de rebanho volta a ser "última escrita vence" (o mesmo
-- comportamento anterior à migração 007). Nenhum dado é perdido e nenhuma
-- coluna é removida: `client_updated_at` continua sendo gravada normalmente,
-- então o guard pode ser religado depois com a migração 012 sem backfill.
--
-- O app 2.5.2 continua funcionando normalmente com o guard desligado: ele só
-- deixa de receber o erro 55006 (que hoje vira "Conflito com uma edição mais
-- recente" na tela de erros de sincronização).

DROP TRIGGER IF EXISTS prevent_stale_rebanho_update ON rebanho;

-- Para religar o guard depois, basta reexecutar:
--   supabase_migrations/012_client_updated_at_rebanho.sql

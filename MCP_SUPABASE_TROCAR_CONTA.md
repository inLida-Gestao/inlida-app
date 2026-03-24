# Como trocar a conta do Supabase MCP no VS Code

## Problema

O MCP do Supabase no VS Code mantém o token de autenticação em cache, mesmo após desinstalar e reinstalar o servidor. Simplesmente fazer login em outra conta pelo navegador **não altera** a conexão do MCP.

## Passo a passo para trocar de conta

### 1. Deletar o token OAuth do Keychain do macOS

Abra o terminal e execute:

```bash
security delete-generic-password -s "copilot-mcp-oauth"
```

> Se retornar "The specified item could not be found", significa que já foi removido ou não estava lá.

### 2. Limpar as credenciais do Supabase no banco de dados interno do VS Code

Execute os seguintes comandos no terminal, um por vez:

```bash
sqlite3 ~/Library/Application\ Support/Code/User/globalStorage/state.vscdb "DELETE FROM ItemTable WHERE key LIKE 'secret://%supabase%';"
```

```bash
sqlite3 ~/Library/Application\ Support/Code/User/globalStorage/state.vscdb "DELETE FROM ItemTable WHERE key LIKE '%supabase%';"
```

```bash
sqlite3 ~/Library/Application\ Support/Code/User/globalStorage/state.vscdb "DELETE FROM ItemTable WHERE key = 'dynamicAuthProviders';"
```

### 3. Limpar credenciais dos workspaces

```bash
for db in ~/Library/Application\ Support/Code/User/workspaceStorage/*/state.vscdb; do sqlite3 "$db" "DELETE FROM ItemTable WHERE key LIKE '%supabase%';" 2>/dev/null; done
```

### 4. Fechar completamente o VS Code

- Use **`Cmd+Q`** para sair completamente (não basta apenas Reload Window)

### 5. Reabrir o VS Code

- Ao abrir, o servidor MCP do Supabase irá solicitar nova autenticação
- Faça login com a conta desejada no navegador

### 6. Verificar a conexão

Peça ao Copilot para verificar:

> "verifique qual organização está conectada no supabase"

---

## Resumo rápido (copiar e colar no terminal)

```bash
security delete-generic-password -s "copilot-mcp-oauth" 2>/dev/null
sqlite3 ~/Library/Application\ Support/Code/User/globalStorage/state.vscdb "DELETE FROM ItemTable WHERE key LIKE '%supabase%';"
sqlite3 ~/Library/Application\ Support/Code/User/globalStorage/state.vscdb "DELETE FROM ItemTable WHERE key = 'dynamicAuthProviders';"
for db in ~/Library/Application\ Support/Code/User/workspaceStorage/*/state.vscdb; do sqlite3 "$db" "DELETE FROM ItemTable WHERE key LIKE '%supabase%';" 2>/dev/null; done
```

Depois feche o VS Code com `Cmd+Q` e reabra.

---

## Notas

- Os tokens ficam armazenados em dois locais: **Keychain do macOS** e **banco SQLite interno do VS Code** (`state.vscdb`)
- Apenas desinstalar/reinstalar o servidor MCP **não limpa** as credenciais
- O comando `Developer: Reload Window` sozinho **não é suficiente** — é necessário fechar o VS Code completamente
- Este procedimento é para **macOS**. Em Linux/Windows os caminhos são diferentes

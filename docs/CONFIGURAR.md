# Configurar o site próprio (sem precisar de conta no Claude)

O site fica no GitHub Pages e os dados num banco gratuito do Supabase. Cada pessoa entra com e-mail e senha.

## 1. Criar o banco (Supabase)

1. Crie uma conta em https://supabase.com (pode entrar com o GitHub).
2. Clique em **New project**. Nome: `validacoes-campo`. Região: **South America (São Paulo)**. Crie uma senha do banco e guarde.
3. Quando o projeto estiver pronto, abra **SQL Editor → New query**, cole o conteúdo de [`supabase/setup.sql`](../supabase/setup.sql) e clique em **Run**.

## 2. Ajustar o login

1. **Authentication → Sign In / Providers**: desligue **Allow new users to sign up** (só você cadastra as pessoas).
2. **Authentication → URL Configuration**: em **Site URL**, coloque `https://ronaldohkjr.github.io/validacoes-campo/`.

## 3. Cadastrar as pessoas

Em **Authentication → Users → Add user → Create new user**:

- E-mail e senha da pessoa
- Marque **Auto Confirm User**

Passe a senha para a pessoa. Depois de entrar, ela pode trocar a senha e o nome dela no menu com o nome dela, no canto de cima do app.

Comece cadastrando você mesmo.

## 4. Ligar o app ao banco

Em **Project Settings → API Keys** (ou **Data API**), copie:

- **Project URL** (ex.: `https://abcdxyz.supabase.co`)
- **Publishable key** (ou **anon public**)

Coloque os dois em [`config.js`](../config.js). Essa chave é pública por natureza: quem protege os dados é o login e as regras criadas no `setup.sql`.

## 5. Publicar no GitHub Pages

No GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: `main` / `(root)` → Save**.

Em 1 ou 2 minutos o site fica em https://ronaldohkjr.github.io/validacoes-campo/

## Esqueceu a senha de alguém?

Não há envio de e-mail automático no plano gratuito. Redefina pelo **SQL Editor**:

```sql
update auth.users
   set encrypted_password = crypt('NovaSenha123', gen_salt('bf'))
 where email = 'pessoa@empresa.com';
```

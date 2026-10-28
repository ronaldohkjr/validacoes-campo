# Configurar o site próprio, passo a passo

Este guia coloca o app no ar num endereço próprio, com login por e-mail e senha, sem precisar de conta no Claude.

## Entenda as peças antes de começar

| Peça | O que é | Para que serve aqui |
|---|---|---|
| **GitHub Pages** | Hospedagem gratuita de sites do GitHub | Mostra as telas do app no endereço `https://ronaldohkjr.github.io/validacoes-campo/` |
| **Supabase** | Serviço gratuito de banco de dados com login pronto | Guarda os projetos e controla quem pode entrar |
| **`setup.sql`** | Um script com instruções para o banco | Cria as "tabelas" (planilhas) e as regras de segurança |
| **`config.js`** | Arquivo do app com o endereço do banco | Diz ao app em qual banco ele deve salvar |

Pense assim: o **GitHub Pages é a vitrine** (o que as pessoas veem) e o **Supabase é o cofre** (onde os dados ficam guardados e onde se confere quem tem a chave).

Tempo estimado: 20 a 30 minutos. Os nomes dos botões do Supabase podem mudar um pouco com o tempo; se não achar um, procure algo parecido no mesmo menu.

---

## Parte 1: Criar a conta e o projeto no Supabase

### 1.1 Criar a conta
1. Acesse **https://supabase.com** e clique em **Start your project** (ou **Sign in**).
2. Escolha **Continue with GitHub** e entre com a mesma conta do GitHub (`ronaldohkjr`). Assim você não precisa criar outra senha.
3. Se ele pedir para criar uma **organização**, coloque um nome qualquer (ex.: `Ronaldo`) e escolha o plano **Free**.

> **O que você fez:** criou sua conta no Supabase. A "organização" é só uma pasta que agrupa seus projetos.

### 1.2 Criar o projeto (o banco de dados)
1. Clique em **New project**.
2. Preencha:
   - **Project name:** `validacoes-campo`
   - **Database password:** clique em **Generate a password** e **guarde essa senha** num lugar seguro. Ela é a senha mestra do banco. O app não usa essa senha, mas você pode precisar dela no futuro.
   - **Region:** **South America (São Paulo)**. Fica mais rápido para quem está no Brasil.
   - **Plan:** Free.
3. Clique em **Create new project** e espere de 1 a 2 minutos, até a tela mostrar que o projeto está pronto.

> **O que você fez:** o Supabase criou um banco de dados só seu, num servidor em São Paulo. Por enquanto ele está vazio.

**Importante sobre o plano gratuito:** se o projeto ficar **7 dias sem nenhum acesso**, o Supabase o pausa. Os dados **não** se perdem: basta entrar no painel e clicar em **Restore project**. Se a equipe usa o app toda semana, isso não acontece.

---

## Parte 2: Criar as tabelas e as regras de segurança

### 2.1 Abrir o editor de SQL
1. No menu da esquerda, clique em **SQL Editor** (ícone de terminal `>_`).
2. Clique em **New query** (ou no **+**).

> **O que é SQL:** é a "linguagem" para dar ordens a um banco de dados. Você não precisa saber escrever: só vai colar um script pronto.

### 2.2 Rodar o script `setup.sql`
1. Abra o arquivo no GitHub: https://github.com/ronaldohkjr/validacoes-campo/blob/main/supabase/setup.sql
2. Clique no botão **Copy raw file** (ícone de copiar, no canto de cima do arquivo).
3. Volte ao Supabase, cole no editor e clique em **Run** (ou `Ctrl + Enter`).
4. Deve aparecer **"Success. No rows returned"**. Esse é o resultado esperado.

Se aparecer um aviso dizendo que o script tem operações "destrutivas", pode confirmar: são só comandos `drop policy if exists`, que removem uma regra antiga com o mesmo nome antes de criar a nova. Nenhum dado é apagado.

> **O que o script faz, parte por parte:**
>
> 1. **Cria a tabela `projects`:** é como uma planilha onde cada linha é um projeto (Piccin, etc.). Todas as informações do projeto (dados, jornada, próximo passo, histórico, checklist) ficam numa coluna chamada `data`.
> 2. **Liga a segurança por linha (RLS):** por padrão, a chave pública do app poderia ler o banco. O RLS tranca tudo e só libera o que as regras permitirem.
> 3. **Cria 4 regras (policies):** quem **fez login** pode ver, criar, editar e excluir projetos. Quem **não fez login** não vê nada. É isso que protege os dados dos seus clientes.
> 4. **Cria a função `merge_project`:** quando alguém altera um campo, o app manda só aquele campo, e a função junta com o resto. Assim, se você muda o telefone do cliente e um colega marca o checklist ao mesmo tempo, nenhuma das duas alterações se perde.
> 5. **Cria a tabela `profiles`:** guarda o nome de cada pessoa, para o histórico mostrar "Ronaldo registrou" em vez de um código. Cada um vê o nome de todos, mas só pode mudar o próprio.
> 6. **Cria um gatilho (trigger):** sempre que você cadastrar uma pessoa nova, o perfil dela é criado sozinho, com o nome inicial igual ao começo do e-mail. Ela pode mudar depois, dentro do app.
> 7. **Liga o tempo real (Realtime):** quando alguém salva algo, a tela dos outros atualiza sem precisar recarregar.

### 2.3 Conferir se deu certo
1. No menu da esquerda, clique em **Table Editor**.
2. Devem aparecer duas tabelas: **projects** e **profiles**, as duas vazias por enquanto.
3. Ao lado do nome delas, **não** deve aparecer o aviso vermelho **"Unrestricted"**. Se aparecer, o RLS não foi ligado: rode o script de novo.

---

## Parte 3: Configurar o login

### 3.1 Impedir que estranhos se cadastrem
1. Menu da esquerda: **Authentication** (ícone de pessoas).
2. Vá em **Sign In / Providers** (em versões antigas: **Providers** ou **Settings**).
3. Desligue **Allow new users to sign up** e clique em **Save**.
4. Confira que o provedor **Email** continua **ligado**: é ele que permite entrar com e-mail e senha.

> **O que você fez:** sem isso, qualquer pessoa que descobrisse o endereço poderia criar uma conta e ver seus dados. Agora **só você** cadastra quem entra.

### 3.2 Informar o endereço do site
1. Ainda em **Authentication**, abra **URL Configuration**.
2. Em **Site URL**, coloque: `https://ronaldohkjr.github.io/validacoes-campo/`
3. Clique em **Save**.

> **O que você fez:** disse ao Supabase qual é o endereço oficial do app. Ele usa isso em links e para aceitar o login vindo desse site.

---

## Parte 4: Cadastrar as pessoas

### 4.1 Cadastrar você primeiro
1. **Authentication → Users → Add user → Create new user**.
2. Preencha:
   - **Email:** `ronaldokjr@hotmail.com`
   - **Password:** uma senha com pelo menos 8 caracteres
   - Marque **Auto Confirm User**
3. Clique em **Create user**.

> **O que você fez:** criou o seu login no app. O **Auto Confirm User** pula o e-mail de confirmação. Isso é necessário porque, no plano gratuito, o Supabase só envia e-mails para os membros da sua conta Supabase, não para a sua equipe.

### 4.2 Cadastrar a equipe
Repita o passo 4.1 para cada pessoa, com o e-mail dela e uma senha provisória. Depois passe a senha para ela por um canal seguro (pessoalmente ou WhatsApp). Ao entrar no app, a pessoa clica no próprio nome, no canto de cima, e pode:
- trocar a senha;
- colocar o nome como quer aparecer no histórico.

### 4.3 Conferir
Em **Table Editor → profiles**, deve aparecer uma linha para cada pessoa cadastrada. Foi o gatilho da Parte 2 que criou essas linhas.

---

## Parte 5: Trazer os projetos que já estão no claude.ai

1. Abra o arquivo **`migracao-dados.sql`** que o Claude enviou na conversa (ele **não** está no GitHub, porque tem dados de cliente).
2. **SQL Editor → New query**, cole o conteúdo inteiro e clique em **Run**.
3. Deve aparecer **"Success"**.
4. Confira em **Table Editor → projects**: deve aparecer o projeto da Piccin.

> **O que você fez:** copiou os projetos do claude.ai para o banco novo. O script também troca o código do seu usuário antigo pelo seu usuário novo, para o histórico continuar mostrando que **você** fez aqueles registros. Por isso este passo precisa vir **depois** de você se cadastrar (4.1).
>
> Depois de importar, use **só o site novo**. Se continuar lançando coisas no claude.ai, elas não aparecem no site, e vice-versa.

---

## Parte 6: Pegar as duas informações para ligar o app ao banco

1. Clique na engrenagem **Project Settings** (no fim do menu da esquerda).
2. Abra **API Keys** (em versões antigas, **API**).
3. Copie:
   - **Project URL**: algo como `https://abcdxyzabcdxyz.supabase.co` (às vezes fica em **Data API** ou no topo da página **API**).
   - **Publishable key**: começa com `sb_publishable_...`. Se não houver, use a **anon public**, que começa com `eyJ...`.
4. Mande os dois para o Claude, ou coloque você mesmo no arquivo `config.js` do repositório.

> **Essas informações são seguras para compartilhar?** Sim. A publishable/anon key foi feita para ficar dentro de sites públicos. Sozinha, ela não abre nada: quem protege os dados é o login e as regras da Parte 2.
>
> **NUNCA** copie nem compartilhe a chave **secret** (`sb_secret_...`) ou a **service_role**. Elas ignoram todas as regras de segurança e dão acesso total ao banco.

---

## Parte 7: Ligar o site no GitHub Pages

1. Abra https://github.com/ronaldohkjr/validacoes-campo/settings/pages
2. Em **Build and deployment → Source**, escolha **Deploy from a branch**.
3. Em **Branch**, escolha **`main`** e a pasta **`/ (root)`**. Clique em **Save**.
4. Espere de 1 a 3 minutos. O endereço aparece no topo dessa mesma página: **https://ronaldohkjr.github.io/validacoes-campo/**

> **O que você fez:** pediu ao GitHub para publicar os arquivos do repositório como um site. Toda vez que o código for atualizado no GitHub, o site atualiza sozinho em alguns minutos.

---

## Parte 8: Testar

1. Abra **https://ronaldohkjr.github.io/validacoes-campo/**
2. Deve aparecer a tela de login. Entre com o seu e-mail e senha.
3. O projeto da Piccin deve aparecer na lista.
4. Faça uma alteração pequena e recarregue a página: ela deve continuar lá.
5. Opcional: abra o site no celular, ou numa janela anônima com o login de outra pessoa, e veja a alteração aparecer.

---

## Problemas comuns

| O que aparece | O que fazer |
|---|---|
| "E-mail ou senha incorretos" | Confira em **Authentication → Users** se a pessoa existe e foi criada com **Auto Confirm User**. |
| Entra, mas a lista fica vazia | Veja se a Parte 5 foi rodada e se a tabela `projects` tem linhas. Se tiver, rode o `setup.sql` de novo (ele não apaga dados). |
| "Modo local" no topo do site | O `config.js` está vazio ou incorreto (Parte 6). |
| Site do GitHub dá erro 404 | Espere alguns minutos depois da Parte 7 e confira se escolheu a branch `main`. |
| Projeto pausado no Supabase | Entre no painel do Supabase e clique em **Restore project**. |

### Esqueceu a senha de alguém?
No **SQL Editor**, rode o comando abaixo, trocando a senha e o e-mail:

```sql
update auth.users
   set encrypted_password = crypt('NovaSenha123', gen_salt('bf'))
 where email = 'pessoa@empresa.com';
```

Passe a senha nova para a pessoa e peça para ela trocar no menu com o nome dela.

### Tirar o acesso de alguém
**Authentication → Users**, clique nos três pontinhos ao lado da pessoa e escolha **Delete user**. Os registros que ela fez continuam no histórico.

# Validações de Campo

App para o supervisor de validação de campo controlar a jornada do cliente e os projetos de agricultura de precisão:

- **Homologação em cliente**: instalação e homologação dos nossos produtos nas máquinas novas dos clientes.
- **Validação de engenharia**: testes e checklist de versões novas de software/firmware e de hardware novo.

## Acessar a plataforma

**https://ronaldohkjr.github.io/validacoes-campo/**

Entre com o e-mail e a senha que o responsável cadastrou para você. Não precisa de conta no Claude.

Para configurar o site e cadastrar pessoas, veja [docs/CONFIGURAR.md](docs/CONFIGURAR.md).

## O que o app faz

- **Jornada** por etapas (Primeiro contato → Visita agendada → Instalação → Homologação → Entrega e treinamento → Acompanhamento em campo → Acompanhamento pós-entrega → Encerrado; a validação de engenharia tem etapas próprias), com data de cada mudança. Uma etapa pode ficar **pendente** mesmo com o projeto já mais à frente, e ser concluída depois.
- **Um próximo passo por vez** (ex.: "entrar em contato daqui 7 dias"): ao concluir, você registra como foi e já agenda o próximo (7, 15, 30, 60, 90 dias ou outra data).
- **Painel inicial** em cartões, com imagem de capa, etapa da jornada e próximo passo de cada projeto, ou em colunas **por etapa**.
- **Agenda**: o próximo passo de cada projeto, separado em atrasados, hoje, próximos 7 dias e mais adiante, além dos projetos sem próximo passo.
- **Abas separadas** em cada projeto: Próximo passo, Histórico, Checklist e Dados.
- **Histórico**: visitas, ligações, mensagens, testes e anotações, com data e autor.
- **Checklist técnico** com OK / Falha / N.A. e observações, a partir de modelos padrão.
- **Relatório** em texto para colar em e-mail ou Teams.

## Como rodar

O app é um único arquivo HTML:

- `app.html`: a fonte, que é publicada no claude.ai.
- `index.html`: a mesma página completa, gerada por `./build.sh`, para abrir direto no navegador.

- **Versão em uso (com dados na nuvem e acesso da equipe):** https://claude.ai/artifact/Dm7zbat1JVLh5LCTWKqFov. Lá os dados ficam salvos num banco compartilhado e cada registro mostra quem fez.
- **Abrindo o `index.html` direto no navegador:** funciona em *modo local*, e os dados ficam salvos só naquele navegador (localStorage).

## Estrutura dos dados

Cada projeto é uma linha da tabela `projects` (campo `data`, JSON) no Supabase, ou um documento da coleção `projects` no claude.ai, com os campos do tipo de projeto, mais:

- `etapa`, `etapasHist[]`, `etapasPend[]`: etapa atual, histórico de mudanças e etapas que ficaram pendentes
- `proximo`: `{texto, tipo: "contato" | "visita" | "tarefa", prazo, criado, autor}` ou `null`
- `diario[]`: `{data, tipo, texto, autor}`
- `checklist[]`: `{grupo, texto, status: "pendente" | "ok" | "falha" | "na", nota}`

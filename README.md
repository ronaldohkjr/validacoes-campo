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
- **Um próximo passo por vez** (ex.: "entrar em contato daqui 7 dias"), agendado pelo botão **+ Próximo passo**. Ao concluir, você registra como foi e já agenda o seguinte. O próximo passo aparece no topo do Histórico, como o item mais à frente da linha do tempo.
- **Cliente no centro, com várias máquinas**: cada projeto é um cliente; a aba **Máquinas** guarda cada máquina instalada, com dados, situação (aguardando instalação → instalada → homologada → entregue) e checklist próprios. Atividades podem ser ligadas às máquinas. Em validação, são **Unidades de teste**.
- **Automático**: registrar uma atividade avança a jornada e a situação das máquinas:
  - Agendar próximo passo do tipo Visita (no Primeiro contato) → *Visita agendada*
  - Instalação → conclui a etapa *Instalação* (máquinas marcadas: *Instalada*)
  - Teste → *Homologação / testes* (validação: *Testes de bancada*)
  - Treinamento → conclui *Entrega e treinamento* (máquinas marcadas: *Entregue / treinada*)
  - Visita ou Suporte depois da entrega → *Acompanhamento em campo*
  - Clicando na etapa atual da jornada dá para concluí-la (ou deixá-la pendente) e seguir para a próxima.
  A jornada só anda para frente; para desfazer, clique na etapa anterior e em "Voltar o projeto para esta etapa".
- **Painel inicial** em cartões, com imagem de capa, etapa da jornada e próximo passo de cada projeto, ou em colunas **por etapa**.
- **Agenda**: o próximo passo de cada projeto, separado em atrasados, hoje, próximos 7 dias e mais adiante, além dos projetos sem próximo passo.
- **Abas** em cada projeto: Histórico (com o próximo passo no topo), Máquinas e Dados.
- **Registrar atividade**: um formulário único, em 4 passos (o que fez, quando, como foi, próximo passo), para visitas, ligações, mensagens, testes e anotações.
- **Fotos e arquivos**: anexe fotos, PDFs, planilhas ou logs ao registrar uma atividade ou agendar um próximo passo (até 25 MB cada).
- **Histórico**: tudo o que foi registrado, com data, autor e anexos.
- **Jornada na lateral** da tela do projeto, sempre visível ao lado das abas.
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
- `maquinas[]`: `{fabricante, modelo, ano, serie, produto, versaoSw, versaoHw, situacao, checklist[]}` (em validação: `{nome, serie, versaoHw, local, situacao, checklist[]}`)
- `checklist[]` (de cada máquina): `{grupo, texto, status: "pendente" | "ok" | "falha" | "na", nota}`

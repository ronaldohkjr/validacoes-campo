# Validações de Campo

App para o supervisor de validação de campo controlar a jornada do cliente e os projetos de agricultura de precisão:

- **Homologação em cliente**: instalação e homologação dos nossos produtos nas máquinas novas dos clientes.
- **Validação de engenharia**: testes e checklist de versões novas de software/firmware e de hardware novo.

## O que o app faz

- **Jornada** por etapas (Primeiro contato → Visita agendada → Instalação → Homologação → Entrega → Acompanhamento → Encerrado; a validação de engenharia tem etapas próprias), com data de cada mudança.
- **Próximos passos**: tarefas com prazo; ao concluir, entram no histórico.
- **Retornos ao cliente**: lembretes em 7, 15, 30, 60 e 90 dias, e um pacote de acompanhamento pós-entrega de 30/60/90 dias.
- **Agenda**: tudo que está atrasado, para hoje, para os próximos 7 dias e mais adiante, de todos os projetos.
- **Histórico**: visitas, ligações, mensagens, testes e anotações, com data e autor.
- **Checklist técnico** com OK / Falha / N.A. e observações, a partir de modelos padrão.
- **Relatório** em texto para colar em e-mail ou Teams.

## Como rodar

O app é um único arquivo: `index.html`.

- **Versão em uso (com dados na nuvem e acesso da equipe):** publicada como Artifact no claude.ai. Lá os dados ficam salvos num banco compartilhado e cada registro mostra quem fez.
- **Abrindo o `index.html` direto no navegador:** funciona em *modo local*, e os dados ficam salvos só naquele navegador (localStorage).

## Estrutura dos dados

Cada projeto é um documento na coleção `projects`, com os campos do tipo de projeto, mais:

- `etapa`, `etapasHist[]`: etapa atual e histórico de mudanças
- `tarefas[]`: `{texto, prazo, tipo: "tarefa" | "contato", feito, feitoEm}`
- `diario[]`: `{data, tipo, texto, autor}`
- `checklist[]`: `{grupo, texto, status: "pendente" | "ok" | "falha" | "na", nota}`

# my-ai-skills

![Repo Type](https://img.shields.io/badge/repository-AI%20Skills%20%26%20Commands-blue)
![Focus](https://img.shields.io/badge/focus-Java%20%7C%20Spring%20Boot%20%7C%20Design-green)
![Status](https://img.shields.io/badge/status-active-success)
![License](https://img.shields.io/badge/license-check%20repository-lightgrey)

Um repositório curado de **Skills** e **Commands** reutilizáveis para engenharia de software, arquitetura, revisão de código, desenvolvimento backend, frontend, UI/UX e fluxos criativos com IA.

A proposta deste repositório é tornar o uso de IA mais estruturado, consistente e reaproveitável, organizando capacidades em dois formatos principais:

- **Commands** para execução direta de tarefas
- **Skills** para especialização por domínio
- Uma base crescente de conhecimento para **Java**, **Spring Boot**, **APIs**, **arquitetura**, **UI/UX** e **design**

---

## Estrutura do repositório

```bash
my-ai-skills/
├── commands/
└── skills/
```

### `commands/`
Arquivos voltados para execução de tarefas específicas.

### `skills/`
Capacidades reutilizáveis com instruções, padrões e fluxos especializados.

---

## Como usar

Você pode usar este repositório como uma biblioteca de especializações para IA.

Fluxo sugerido:

1. Escolha um **command** quando quiser executar uma tarefa direta.
2. Escolha uma **skill** quando quiser aplicar uma especialidade ou padrão recorrente.
3. Copie o conteúdo do arquivo desejado ou adapte a ideia para o seu contexto.
4. Combine múltiplos arquivos quando a tarefa exigir mais de uma competência.

### Exemplos rápidos
- Quer criar uma API nova? Use `commands/api.md`
- Quer revisar um PR Java? Use `skills/java-code-review`
- Quer reorganizar a arquitetura? Use `commands/architecture.md` + `skills/clean-project-structure`
- Quer melhorar logs e observabilidade? Use `skills/logging-patterns`
- Quer criar uma interface mais refinada? Use `skills/frontend-design` + `skills/ui-styling`

---

## Visão geral rápida

### Commands

| Arquivo | Objetivo | Use quando |
|---|---|---|
| `api.md` | Criar ou evoluir APIs | você quiser construir APIs REST prontas para produção |
| `architecture.md` | Reorganizar arquitetura existente | você quiser refatorar estrutura sem mudar comportamento |
| `debug.md` | Investigar bugs | você estiver analisando falhas, erros ou comportamento inesperado |
| `feature.md` | Implementar funcionalidades | você quiser entregar uma feature de ponta a ponta |
| `fullapp.md` | Criar aplicação completa | você quiser montar um MVP ou sistema do zero |
| `multi-agent.md` | Simular fluxo com múltiplos agentes | você quiser separar arquitetura, implementação, revisão e otimização |
| `perf.md` | Otimizar desempenho | você quiser reduzir latência ou melhorar escalabilidade |
| `refactor.md` | Refatorar codebase | você estiver lidando com projeto legado ou complexidade crescente |
| `ship.md` | Preparar versionamento e commit | você quiser organizar melhor o processo de entrega |
| `sysdesign.md` | Projetar sistemas escaláveis | você estiver fazendo system design ou arquitetura de produto |
| `uicomp.md` | Criar componentes de UI | você quiser componentes reutilizáveis e acessíveis |

### Skills

| Skill | Objetivo | Use quando |
|---|---|---|
| `api-contract-review` | Revisar contratos de API | você quiser validar design de requests, responses e status codes |
| `banner-design` | Criar banners | você quiser peças visuais promocionais ou institucionais |
| `brand` | Trabalhar identidade de marca | você quiser consistência de voz, visual e mensagem |
| `clean-code` | Melhorar qualidade de código | você quiser código mais legível e sustentável |
| `clean-project-structure` | Reorganizar estrutura de projeto | você quiser fronteiras mais claras no projeto |
| `design` | Atender demandas visuais amplas | você quiser uma skill criativa mais abrangente |
| `design-patterns` | Aplicar padrões de projeto | você quiser extensibilidade e desacoplamento |
| `design-system` | Estruturar base visual escalável | você quiser tokens, padrões e consistência |
| `frontend-design` | Criar interfaces refinadas | você quiser páginas e apps com melhor acabamento visual |
| `java-architect` | Arquitetura Java enterprise | você quiser visão arquitetural sólida em Java |
| `java-code-review` | Revisar código Java | você quiser validar qualidade técnica antes de merge |
| `jpa-patterns` | Melhorar camada de persistência | você quiser evitar problemas comuns com JPA/Hibernate |
| `kafka-client-setup` | Configurar cliente Kafka | você quiser integrar Kafka com Spring Boot |
| `keyset-pagination` | Paginação eficiente | você quiser paginação escalável com cursor |
| `logging-patterns` | Evoluir logging | você quiser logs melhores para debugging e observabilidade |
| `slides` | Criar apresentações | você quiser decks mais estratégicos e visuais |
| `spring-boot-engineer` | Implementação com Spring Boot | você quiser construir serviços robustos em Spring |
| `spring-boot-patterns` | Aplicar padrões Spring Boot | você quiser consistência arquitetural no framework |
| `ui-styling` | Refinar estilo visual | você quiser melhorar aparência e consistência da UI |
| `ui-ux-pro-max` | Elevar nível de UX/UI | você quiser uma visão mais avançada de experiência e interface |

---

## Commands

A pasta `commands` contém prompts orientados à execução de tarefas comuns de engenharia de software.

### `api.md`
Projeta e desenvolve APIs limpas e prontas para produção, com foco em:
- validação
- autenticação/autorização
- DTOs
- tratamento de erros
- separação entre controller, service e repository

**Use quando:** você quiser criar ou evoluir APIs REST de forma estruturada e pronta para produção.

**Exemplo de uso:**
> “Quero criar uma API REST para cadastro de clientes com autenticação JWT, validação e tratamento de erros.”

---

### `architecture.md`
Reconstrói ou reorganiza uma base existente em uma arquitetura mais limpa, preservando o comportamento atual.

**Use quando:** você precisar refatorar a estrutura do projeto sem alterar a lógica de negócio.

**Exemplo de uso:**
> “Analise este projeto e proponha uma nova arquitetura em camadas mantendo o comportamento atual.”

---

### `debug.md`
Investiga bugs com foco em causa raiz e propõe correções sólidas para produção.

**Use quando:** você estiver analisando erros, comportamentos inesperados, problemas de concorrência ou falhas difíceis de rastrear.

**Exemplo de uso:**
> “Estou tendo `NullPointerException` em produção em alguns cenários. Me ajude a encontrar a causa raiz e corrigir.”

---

### `feature.md`
Implementa funcionalidades completas com preocupação em arquitetura, edge cases, tratamento de erros e desempenho.

**Use quando:** você quiser construir uma nova funcionalidade de ponta a ponta com qualidade de produção.

**Exemplo de uso:**
> “Implemente uma funcionalidade de favoritar produtos com persistência, validações e endpoint REST.”

---

### `fullapp.md`
Cria uma aplicação completa do zero, incluindo:
- arquitetura
- estrutura de pastas
- modelo de dados
- endpoints
- interface
- base escalável para MVP

**Use quando:** você quiser montar um sistema completo ou um MVP a partir do zero.

**Exemplo de uso:**
> “Quero criar um app de gestão de tarefas com backend, banco, frontend e estrutura inicial pronta para evoluir.”

---

### `multi-agent.md`
Simula um fluxo com 4 agentes:
1. Architect
2. Engineer
3. Reviewer
4. Optimizer

**Use quando:** você quiser um processo mais rigoroso de implementação, com etapas separadas de arquitetura, desenvolvimento, revisão e otimização.

**Exemplo de uso:**
> “Quero que você trate esta feature como um fluxo multi-agente: arquitetura, implementação, revisão e otimização.”

---

### `perf.md`
Otimiza código com foco em:
- velocidade
- uso de memória
- escalabilidade
- eficiência no acesso a banco

**Use quando:** você quiser melhorar latência, throughput ou eficiência geral do sistema.

**Exemplo de uso:**
> “Analise este endpoint que está lento e proponha otimizações de código, banco e consumo de memória.”

---

### `refactor.md`
Analisa um codebase desconhecido, identifica problemas de manutenibilidade e propõe estratégias de refatoração.

**Use quando:** você estiver entrando em um projeto legado ou planejando uma refatoração de médio ou grande porte.

**Exemplo de uso:**
> “Leia esta base e proponha um plano de refatoração para reduzir acoplamento e duplicação.”

---

### `ship.md`
Analisa alterações no Git, sugere conventional commit e ajuda a preparar o fluxo de commit/push com mais segurança.

**Use quando:** você quiser empacotar e versionar mudanças com mais clareza e padronização.

**Exemplo de uso:**
> “Com base nas mudanças feitas, gere uma mensagem de commit no padrão conventional commits.”

---

### `sysdesign.md`
Projeta sistemas escaláveis e implementa uma versão mínima viável com visão de produção.

**Use quando:** você estiver pensando arquitetura de sistemas, entrevistas de system design ou criação de produtos escaláveis.

**Exemplo de uso:**
> “Desenhe a arquitetura de um sistema de pagamentos com alta disponibilidade e proponha uma versão mínima.”

---

### `uicomp.md`
Cria componentes de interface reutilizáveis, acessíveis e prontos para produção, incluindo:
- estados de loading, vazio e erro
- responsividade
- acessibilidade
- boa definição de props em TypeScript

**Use quando:** você quiser construir componentes frontend robustos e reutilizáveis.

**Exemplo de uso:**
> “Crie um componente de tabela reutilizável com estados de loading, empty state e paginação.”

---

## Skills

A pasta `skills` contém capacidades reutilizáveis e especializadas por domínio.

---

## Backend, Java e Arquitetura

### `api-contract-review`
Revisa contratos de APIs REST com foco em:
- semântica HTTP
- versionamento
- compatibilidade retroativa
- consistência de request/response
- status codes corretos

**Use quando:** você quiser revisar ou validar contratos de API antes de publicar ou integrar.

**Exemplo de uso:**
> “Revise este contrato OpenAPI e identifique problemas de versionamento, status code e compatibilidade.”

---

### `clean-code`
Aplica princípios clássicos de Clean Code, como:
- DRY
- KISS
- YAGNI
- melhor nomeação
- legibilidade
- manutenibilidade

**Use quando:** você quiser melhorar clareza, simplicidade e qualidade do código.

**Exemplo de uso:**
> “Reescreva esta classe aplicando Clean Code e explique os principais ganhos.”

---

### `clean-project-structure`
Padroniza a organização de projetos Java/Kotlin com responsabilidades bem separadas entre:
- entrypoint
- config
- usecases
- entities
- providers
- dataproviders
- exceptions

**Use quando:** você quiser reorganizar a estrutura do projeto com fronteiras mais claras.

**Exemplo de uso:**
> “Proponha uma estrutura de pacotes mais limpa para este projeto Spring Boot.”

---

### `design-patterns`
Fornece orientação prática sobre padrões como:
- Factory
- Builder
- Strategy
- Observer
- Decorator
- Adapter
- Template Method

**Use quando:** você quiser tornar o código mais extensível, desacoplado e orientado a boas práticas de design.

**Exemplo de uso:**
> “Qual pattern se encaixa melhor neste cenário de múltiplas regras de cálculo e como implementar?”

---

### `java-architect`
Skill de arquitetura Java enterprise com foco em:
- Spring Boot 3.x
- microservices
- WebFlux
- otimização com JPA
- Spring Security
- aplicações cloud-native

**Use quando:** você estiver modelando ou implementando sistemas robustos em Java com visão arquitetural.

**Exemplo de uso:**
> “Projete a arquitetura de um sistema Java com Spring Boot, segurança, observabilidade e integração entre serviços.”

---

### `java-code-review`
Faz revisão sistemática de código Java com foco em:
- null safety
- exception handling
- concorrência
- collections/streams
- performance
- uso idiomático da linguagem

**Use quando:** você quiser revisar PRs ou validar qualidade técnica de código Java antes de merge.

**Exemplo de uso:**
> “Faça uma code review detalhada desta classe Java e aponte riscos técnicos e melhorias.”

---

### `jpa-patterns`
Cobre padrões e armadilhas de JPA/Hibernate, como:
- N+1
- lazy loading
- transações
- estratégias de fetch
- otimização de queries
- optimistic locking

**Use quando:** você estiver resolvendo problemas de persistência ou melhorando acesso a banco com JPA.

**Exemplo de uso:**
> “Analise este repositório JPA e veja se há risco de N+1, lazy initialization ou queries ineficientes.”

---

### `kafka-client-setup`
Guia a integração da biblioteca `io.github.santannaf:kafka` em projetos Spring Boot 4.x.

Inclui:
- dependências
- configuração de producer e consumer
- SSL/TLS
- batch
- conexões secundárias
- ambiente local com Docker

**Use quando:** você quiser configurar rapidamente clientes Kafka usando a biblioteca do repositório/ecossistema associado.

**Exemplo de uso:**
> “Me ajude a configurar producer e consumer Kafka neste projeto Spring Boot com suporte a SSL.”

---

### `keyset-pagination`
Promove o uso de paginação por cursor/keyset em vez de offset pagination.

**Use quando:** você quiser paginação mais performática, consistente e escalável em APIs e consultas SQL.

**Exemplo de uso:**
> “Transforme esta paginação por offset em keyset pagination e mostre como ficaria o endpoint.”

---

### `logging-patterns`
Aplica boas práticas de logging em Java usando:
- SLF4J
- logs estruturados em JSON
- MDC com correlation IDs
- formatação amigável para observabilidade e IA

**Use quando:** você quiser evoluir logs da aplicação para debugging, tracing e observabilidade.

**Exemplo de uso:**
> “Reestruture esta estratégia de logs para suportar correlation ID, JSON e melhor rastreabilidade.”

---

### `spring-boot-engineer`
Skill especializada em implementação com Spring Boot, cobrindo:
- APIs REST
- Spring Security 6
- Spring Data JPA
- WebFlux
- microservices
- observabilidade
- testes

**Use quando:** você quiser construir serviços Spring Boot prontos para produção.

**Exemplo de uso:**
> “Implemente um serviço Spring Boot com controller, service, repository, validação e testes.”

---

### `spring-boot-patterns`
Reúne padrões reutilizáveis e boas práticas para aplicações Spring Boot.

**Use quando:** você quiser manter consistência arquitetural entre services, controllers, repositories e tratamento de exceções.

**Exemplo de uso:**
> “Revise este projeto e sugira padrões Spring Boot para melhorar consistência e manutenção.”

---

## Frontend, UI/UX e Design de Interface

### `frontend-design`
Cria interfaces frontend com forte direção visual e acabamento de nível de produção.

**Use quando:** você quiser montar páginas, dashboards, landing pages ou aplicações com aparência mais refinada.

**Exemplo de uso:**
> “Crie uma landing page moderna para produto SaaS com visual premium.”

---

### `ui-styling`
Foca em interfaces bonitas e acessíveis usando:
- shadcn/ui
- Radix UI
- Tailwind CSS
- temas
- layouts responsivos
- consistência visual

**Use quando:** você quiser melhorar o estilo visual e a consistência da interface.

**Exemplo de uso:**
> “Refine esta interface com Tailwind e shadcn/ui para deixá-la mais moderna e consistente.”

---

### `ui-ux-pro-max`
Skill avançada de UI/UX cobrindo:
- dezenas de estilos visuais
- sistemas de cor e tipografia
- padrões web/mobile
- acessibilidade
- layout
- motion
- gráficos
- design de componentes

**Use quando:** você quiser planejar, revisar ou elevar o nível de UX/UI de um produto.

**Exemplo de uso:**
> “Avalie esta interface do ponto de vista de UX/UI e proponha melhorias de layout, hierarquia e acessibilidade.”

---

## Marca, Criatividade e Apresentações

### `brand`
Dá suporte para:
- voz de marca
- identidade visual
- framework de mensagens
- consistência de ativos
- alinhamento com guia de estilo

**Use quando:** você quiser criar ou manter consistência de marca em materiais e produtos.

**Exemplo de uso:**
> “Defina uma voz de marca e um direcionamento visual para uma fintech B2B.”

---

### `design-system`
Foca em:
- design tokens
- especificações de componentes
- design sistemático
- arquitetura com CSS variables
- consistência visual com branding

**Use quando:** você quiser estruturar uma base escalável de design para produtos e interfaces.

**Exemplo de uso:**
> “Monte a base de um design system com tokens, tipografia, cores e componentes principais.”

---

### `design`
Skill ampla de design que cobre:
- identidade de marca
- design systems
- UI styling
- geração de logos
- identidade corporativa
- mockups
- slides
- banners
- ícones
- criativos para redes sociais

**Use quando:** você quiser uma capacidade mais abrangente para demandas visuais e criativas.

**Exemplo de uso:**
> “Preciso de uma direção visual completa para produto digital, incluindo identidade, interface e peças promocionais.”

---

### `banner-design`
Cria banners para:
- redes sociais
- anúncios
- hero sections
- materiais impressos
- campanhas visuais

**Use quando:** você quiser gerar peças visuais promocionais ou institucionais com direção criativa.

**Exemplo de uso:**
> “Crie um conceito de banner para campanha de lançamento com foco em conversão.”

---

### `slides`
Cria apresentações estratégicas em HTML com foco em:
- layout responsivo
- Chart.js
- copywriting
- narrativa visual
- organização de slides

**Use quando:** você quiser montar apresentações, pitch decks ou materiais executivos com mais impacto visual.

**Exemplo de uso:**
> “Monte a estrutura de um pitch deck para apresentar um produto B2B a investidores.”

---

## Combinações recomendadas

Algumas combinações úteis dentro do repositório:

### Criar backend robusto
- `commands/api.md`
- `skills/spring-boot-engineer`
- `skills/api-contract-review`
- `skills/logging-patterns`

### Refatorar projeto legado Java
- `commands/refactor.md`
- `commands/architecture.md`
- `skills/clean-code`
- `skills/clean-project-structure`
- `skills/java-code-review`

### Melhorar persistência e performance
- `commands/perf.md`
- `skills/jpa-patterns`
- `skills/keyset-pagination`
- `skills/logging-patterns`

### Criar interface mais forte visualmente
- `commands/uicomp.md`
- `skills/frontend-design`
- `skills/ui-styling`
- `skills/ui-ux-pro-max`

### Criar material visual e apresentações
- `skills/design`
- `skills/brand`
- `skills/design-system`
- `skills/banner-design`
- `skills/slides`

---


## Exemplos de prompts combinando commands + skills

Abaixo estão exemplos prontos de prompts para combinar **1 command + 3 skills** do repositório.  
A ideia é simples:

- o **command** conduz o tipo de tarefa
- as **skills** aprofundam a qualidade da resposta em áreas específicas

---

### 1) Criar uma API REST completa

**Combinação:**
- Command: `api.md`
- Skills:
    - `spring-boot-engineer`
    - `api-contract-review`
    - `logging-patterns`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- api.md

Skills:
- spring-boot-engineer
- api-contract-review
- logging-patterns

Objetivo:
Criar uma API REST para cadastro e consulta de pedidos de e-commerce.

Contexto:
- Stack: Java 24 + Spring Boot
- Funcionalidades:
  - criar pedido
  - buscar pedido por id
  - listar pedidos com paginação
  - atualizar status do pedido
- Quero autenticação JWT
- Quero validação de payload
- Quero logs estruturados com correlationId
- Quero contratos REST consistentes

Instruções:
- Use `api.md` para conduzir a construção da API
- Use `spring-boot-engineer` para definir a implementação Spring Boot pronta para produção
- Use `api-contract-review` para garantir semântica HTTP, status codes corretos e contratos consistentes
- Use `logging-patterns` para definir uma estratégia de logs estruturados

Quero como saída:
1. arquitetura sugerida
2. estrutura de pacotes
3. endpoints REST
4. DTOs
5. tratamento de exceções
6. estratégia de logging
7. código inicial
```

---

### 2) Refatorar um projeto legado Java

**Combinação:**
- Command: `refactor.md`
- Skills:
    - `clean-code`
    - `clean-project-structure`
    - `java-code-review`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- refactor.md

Skills:
- clean-code
- clean-project-structure
- java-code-review

Objetivo:
Analisar uma base Java legada e propor uma refatoração.

Contexto:
- Projeto Spring Boot monolítico
- Há classes muito grandes, duplicação de lógica e forte acoplamento
- Existem services acessando diretamente detalhes de infraestrutura
- Quero melhorar legibilidade, organização e manutenção

Instruções:
- Use `refactor.md` para conduzir a análise e o plano de refatoração
- Use `clean-code` para identificar problemas de legibilidade, duplicação e nomeação
- Use `clean-project-structure` para propor uma nova organização do projeto
- Use `java-code-review` para apontar riscos técnicos e melhorias

Quero como saída:
1. diagnóstico dos problemas
2. proposta de nova estrutura
3. plano de refatoração por etapas
4. exemplos de antes e depois
5. riscos da migração
```

---

### 3) Melhorar performance de uma API com banco de dados

**Combinação:**
- Command: `perf.md`
- Skills:
    - `jpa-patterns`
    - `keyset-pagination`
    - `logging-patterns`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- perf.md

Skills:
- jpa-patterns
- keyset-pagination
- logging-patterns

Objetivo:
Melhorar a performance de uma API que consulta dados paginados no banco.

Contexto:
- Stack: Spring Boot + JPA + PostgreSQL
- O endpoint está lento
- Há suspeita de N+1
- A paginação atual usa offset
- Quero melhorar observabilidade para identificar gargalos

Instruções:
- Use `perf.md` para conduzir a análise de performance
- Use `jpa-patterns` para identificar problemas de fetch, N+1 e queries ineficientes
- Use `keyset-pagination` para propor paginação mais performática
- Use `logging-patterns` para melhorar rastreabilidade e análise de gargalos

Quero como saída:
1. principais gargalos
2. mudanças recomendadas no acesso a dados
3. proposta de keyset pagination
4. melhorias de logging
5. exemplo de código otimizado
```

---

### 4) Criar uma feature nova em Spring Boot

**Combinação:**
- Command: `feature.md`
- Skills:
    - `spring-boot-engineer`
    - `clean-code`
    - `spring-boot-patterns`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- feature.md

Skills:
- spring-boot-engineer
- clean-code
- spring-boot-patterns

Objetivo:
Implementar uma funcionalidade de favoritos para produtos.

Contexto:
- Stack: Java + Spring Boot
- O usuário deve conseguir favoritar e desfavoritar produtos
- Quero endpoint REST
- Quero service bem estruturado
- Quero código limpo e consistente com boas práticas Spring Boot

Instruções:
- Use `feature.md` para conduzir a implementação da funcionalidade
- Use `spring-boot-engineer` para montar a solução técnica
- Use `clean-code` para garantir clareza e boa modelagem
- Use `spring-boot-patterns` para manter consistência arquitetural

Quero como saída:
1. arquitetura da feature
2. endpoints
3. entidades e DTOs
4. service/repository
5. tratamento de erros
6. código inicial
```

---

### 5) Projetar um sistema escalável

**Combinação:**
- Command: `sysdesign.md`
- Skills:
    - `java-architect`
    - `logging-patterns`
    - `design-patterns`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- sysdesign.md

Skills:
- java-architect
- logging-patterns
- design-patterns

Objetivo:
Projetar um sistema de pagamentos com alta disponibilidade.

Contexto:
- O sistema deve suportar alto volume
- Precisa ter resiliência, rastreabilidade e boa separação de responsabilidades
- Quero visão arquitetural e também uma base mínima implementável

Instruções:
- Use `sysdesign.md` para conduzir o desenho da solução
- Use `java-architect` para orientar a arquitetura Java/Spring
- Use `logging-patterns` para definir observabilidade e rastreabilidade
- Use `design-patterns` para propor padrões úteis na modelagem

Quero como saída:
1. arquitetura de alto nível
2. componentes principais
3. fluxos críticos
4. padrões recomendados
5. versão mínima viável
```

---

### 6) Reorganizar a arquitetura de um projeto existente

**Combinação:**
- Command: `architecture.md`
- Skills:
    - `clean-project-structure`
    - `spring-boot-patterns`
    - `design-patterns`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- architecture.md

Skills:
- clean-project-structure
- spring-boot-patterns
- design-patterns

Objetivo:
Reorganizar a arquitetura de um projeto já existente.

Contexto:
- Projeto Spring Boot cresceu sem padrão claro
- Há mistura de regra de negócio, controller e acesso a dados
- Quero preservar comportamento e melhorar organização

Instruções:
- Use `architecture.md` para conduzir a reorganização arquitetural
- Use `clean-project-structure` para propor uma estrutura de pacotes melhor
- Use `spring-boot-patterns` para alinhar a solução com boas práticas do framework
- Use `design-patterns` para sugerir padrões que reduzam acoplamento

Quero como saída:
1. diagnóstico arquitetural
2. nova estrutura sugerida
3. responsabilidades por camada
4. plano de migração
5. exemplos práticos de reorganização
```

---

### 7) Criar uma aplicação completa do zero

**Combinação:**
- Command: `fullapp.md`
- Skills:
    - `spring-boot-engineer`
    - `frontend-design`
    - `ui-styling`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- fullapp.md

Skills:
- spring-boot-engineer
- frontend-design
- ui-styling

Objetivo:
Criar um MVP completo de gestão de tarefas.

Contexto:
- Quero backend e frontend
- Backend em Spring Boot
- Frontend com visual moderno
- O sistema deve ter cadastro, listagem, edição e remoção de tarefas
- Quero base pronta para evoluir

Instruções:
- Use `fullapp.md` para conduzir a criação da aplicação completa
- Use `spring-boot-engineer` para a parte backend
- Use `frontend-design` para definir a interface
- Use `ui-styling` para refinar o estilo visual

Quero como saída:
1. arquitetura geral
2. estrutura de pastas
3. modelo de dados
4. endpoints
5. proposta de frontend
6. código inicial
```

---

### 8) Criar um componente de interface reutilizável

**Combinação:**
- Command: `uicomp.md`
- Skills:
    - `frontend-design`
    - `ui-styling`
    - `ui-ux-pro-max`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- uicomp.md

Skills:
- frontend-design
- ui-styling
- ui-ux-pro-max

Objetivo:
Criar um componente de dashboard para exibir métricas financeiras.

Contexto:
- Quero um card com gráfico, valor principal, variação percentual e filtros
- O componente deve ser responsivo
- Quero loading state, empty state e error state
- Desejo visual moderno e profissional

Instruções:
- Use `uicomp.md` para construir o componente reutilizável
- Use `frontend-design` para elevar o nível visual
- Use `ui-styling` para padronizar estilo, cores e tipografia
- Use `ui-ux-pro-max` para melhorar UX, hierarquia visual e acessibilidade

Quero como saída:
1. proposta de UX/UI
2. estrutura do componente
3. props TypeScript
4. código do componente
5. sugestões visuais
```

---

### 9) Criar materiais visuais de marca e campanha

**Combinação:**
- Command: `feature.md`
- Skills:
    - `brand`
    - `design`
    - `banner-design`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- feature.md

Skills:
- brand
- design
- banner-design

Objetivo:
Criar uma campanha visual de lançamento para um produto digital.

Contexto:
- O produto é um SaaS B2B
- Quero coerência entre mensagem, identidade visual e peças promocionais
- Preciso de direção visual para banner principal, peça de rede social e conceito da campanha

Instruções:
- Use `feature.md` para tratar isso como uma entrega estruturada
- Use `brand` para definir voz e alinhamento de marca
- Use `design` para propor a direção criativa geral
- Use `banner-design` para detalhar as peças promocionais

Quero como saída:
1. conceito da campanha
2. direcionamento de marca
3. proposta visual
4. sugestões de peças
5. textos curtos para campanha
```

---

### 10) Criar uma apresentação estratégica

**Combinação:**
- Command: `fullapp.md`
- Skills:
    - `slides`
    - `design-system`
    - `brand`

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- fullapp.md

Skills:
- slides
- design-system
- brand

Objetivo:
Montar uma apresentação estratégica para vender um produto B2B.

Contexto:
- A apresentação será usada em reunião comercial
- Quero narrativa clara, identidade visual consistente e estrutura profissional
- O material deve transmitir confiança e valor de negócio

Instruções:
- Use `fullapp.md` para estruturar a entrega completa
- Use `slides` para montar a lógica da apresentação
- Use `design-system` para garantir consistência visual
- Use `brand` para alinhar tom, mensagem e percepção da marca

Quero como saída:
1. estrutura dos slides
2. narrativa principal
3. recomendação visual
4. conteúdo por slide
5. orientações para apresentação
```

---

## Modelo base para criar seus próprios prompts

Você também pode reutilizar este modelo e trocar os nomes dos arquivos conforme o objetivo:

```md
Quero que você combine os seguintes arquivos do meu repositório:

Commands:
- [command]

Skills:
- [skill 1]
- [skill 2]
- [skill 3]

Objetivo:
[descreva o que você quer construir, revisar, otimizar ou criar]

Contexto:
- [stack]
- [problema]
- [restrições]
- [requisitos]

Instruções:
- Use `[command]` para conduzir a tarefa
- Use `[skill 1]` para [especialidade]
- Use `[skill 2]` para [especialidade]
- Use `[skill 3]` para [especialidade]

Quero como saída:
1. [...]
2. [...]
3. [...]
4. [...]
5. [...]
```

## Casos de uso sugeridos

Este repositório é especialmente útil para quem quer usar IA para:

- construir APIs e serviços backend
- revisar código Java e Spring Boot
- refatorar sistemas legados
- projetar arquiteturas escaláveis
- melhorar performance e logging
- aplicar boas práticas com JPA e paginação
- criar interfaces frontend mais polidas
- produzir materiais visuais, branding e apresentações

---

## Para quem este repositório é útil

- Backend engineers
- Desenvolvedores Java / Spring Boot
- Arquitetos de software
- Frontend engineers
- Product engineers
- Designers que trabalham com fluxos assistidos por IA
- Desenvolvedores que criam bibliotecas de prompts, skills ou automações

---

## Filosofia do repositório

A ideia principal deste projeto é simples:

> Tirar o uso de IA do prompt genérico e levar para capacidades reutilizáveis de engenharia e design.

Em vez de reescrever os mesmos prompts repetidamente, o repositório organiza conhecimento em:
- **commands** para execução
- **skills** para especialização

Isso torna o uso de IA mais:
- consistente
- reaproveitável
- sustentável
- escalável entre projetos

---

## Licença

Verifique o repositório e os arquivos individualmente caso exista alguma definição específica de licença ou metadados adicionais.

---

## Autor

Mantido por [santannaf](https://github.com/santannaf)

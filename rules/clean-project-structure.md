# AGENTS.md

## Objetivo

Este arquivo define minhas regras globais de engenharia para qualquer projeto trabalhado com Codex.

Estas instruções devem ser consideradas em todos os repositórios, independentemente da linguagem, framework ou contexto específico.

Quando existir um `AGENTS.md` dentro do repositório, ele pode complementar estas regras com detalhes específicos do projeto.

Quando existir conflito entre este arquivo global e um arquivo específico do repositório, siga a instrução mais específica, desde que ela não viole segurança, clareza, qualidade ou autorização explícita do usuário.

---

## Fluxo obrigatório de trabalho

Para qualquer tarefa relevante, siga o fluxo:

1. Entender a tarefa.
2. Separar o contexto em negócio, tecnologia e decomposição de subtarefas.
3. Criar um plano antes de alterar código quando a tarefa for grande, arriscada ou ambígua.
4. Listar arquivos que serão criados, alterados ou removidos.
5. Aguardar aprovação quando eu pedir modo plano.
6. Implementar em pequenos passos.
7. Executar build, testes ou validações possíveis.
8. Explicar o que foi alterado e como validar.

Fluxo conceitual esperado:

Tarefa -> Planejamento -> Execução -> Código

Durante o planejamento, considere:

- Negócio
- Tecnologia
- Decomposição de subtarefas
- Implementação
- QA
- Revisão

Nunca comece implementando sem antes entender o contexto quando a tarefa for grande, estrutural, arriscada ou ambígua.

---

## Regra global de estrutura de projeto

- Para qualquer projeto, em qualquer linguagem, aplique a skill `clean-project-structure` antes de propor, criar ou modificar a estrutura de pastas, módulos, packages, namespaces ou camadas.
- A organização do projeto deve seguir o que estiver definido na skill `clean-project-structure`.
- Não assuma automaticamente uma estrutura baseada apenas em convenções genéricas como Controller, Service, Repository, UseCase, Handler, Manager ou Utils.
- Use essas estruturas somente quando a skill `clean-project-structure` indicar que fazem sentido para o contexto.
- Quando houver conflito entre uma convenção de framework e a skill `clean-project-structure`, a skill deve ter prioridade.
- Antes de criar novas pastas, módulos ou camadas, explique qual parte da skill `clean-project-structure` justifica essa decisão.
- Evite criar camadas, abstrações ou separações artificiais apenas por padrão de mercado.
- A estrutura deve refletir o domínio, o tamanho do projeto, o tipo de aplicação e o nível real de complexidade.
- Em projetos pequenos, prefira estruturas simples.
- Em projetos maiores, separe responsabilidades de forma clara e justificada.
- Não altere a estrutura existente de um projeto sem avaliar impacto, riscos e compatibilidade.

---

## Regras gerais de engenharia

- Escreva código simples, legível e objetivo.
- Prefira clareza em vez de abstrações prematuras.
- Não implemente funcionalidades fora do escopo solicitado.
- Não adicione dependências sem necessidade clara.
- Não altere nomes de projeto, pacotes, módulos, namespaces ou estrutura sem justificar.
- Não remova arquivos sem explicar o motivo.
- Não deixe código morto, comentado ou experimental.
- Não ignore erros silenciosamente.
- Trate entradas externas como não confiáveis.
- Valide dados recebidos em APIs, consumers, jobs, CLIs e integrações.
- Use logs com contexto suficiente para diagnóstico.
- Não exponha segredos em código, logs, README, exemplos ou testes.
- Use variáveis de ambiente para tokens, senhas, connection strings e chaves.
- Não faça commits automaticamente.
- Não execute comandos destrutivos sem autorização explícita.
- Não rode comandos que removam arquivos, branches, volumes ou bancos sem confirmação.
- Não introduza arquitetura complexa sem necessidade.
- Não use nomes genéricos quando houver nome de domínio mais claro.
- Não modifique configuração sensível sem explicar o impacto.
- Preserve o comportamento existente quando a tarefa for incremental.

---

## Regras globais de versionamento

### Java

- Para novos projetos Java, use Java 25, salvo se o contexto exigir outra versão.
- Para projetos existentes, preserve a versão já configurada, a menos que a tarefa peça migração.
- Não altere a versão do Java em projeto existente sem explicar impacto, riscos e ajustes necessários.
- Prefira APIs modernas da JDK quando isso simplificar o código.
- Não introduza frameworks pesados sem justificativa.
- Não altere build tool, como Maven ou Gradle, sem necessidade clara.

### C#

- Para novos projetos C#, use .NET 10, salvo se o contexto exigir outra versão.
- Para projetos existentes, preserve o `TargetFramework` já configurado, a menos que a tarefa peça migração.
- Não altere a versão do .NET em projeto existente sem explicar impacto, riscos e ajustes necessários.
- Para APIs HTTP, prefira ASP.NET Core.
- Para APIs pequenas e MVPs, prefira Minimal APIs quando fizer sentido.
- Para aplicações maiores, organize a aplicação conforme a skill `clean-project-structure`.
- Não altere formato de solution ou project sem necessidade clara.

---

## Regras globais para C#

### Nomeação

- Use PascalCase para classes, records, structs, enums, métodos, propriedades e constantes públicas.
- Use camelCase para variáveis locais e parâmetros.
- Use `_camelCase` para campos privados.
- Use nomes claros e orientados ao domínio.
- Evite abreviações obscuras.
- Evite nomes genéricos como `Manager`, `Helper`, `Utils` e `Processor` quando houver nome de domínio melhor.
- Métodos devem expressar ação ou intenção.
- Tipos devem expressar conceito de domínio ou responsabilidade técnica clara.

Exemplos conceituais:

- Classe: `PaymentTransactionService`
- Método: `CreateTransactionAsync`
- Propriedade: `TransactionId`
- Variável local: `transactionId`
- Parâmetro: `cancellationToken`
- Campo privado: `_logger`

---

### Organização

- A estrutura do projeto deve seguir a skill `clean-project-structure`.
- Use `file-scoped namespace` quando houver namespace explícito.
- Use `record` ou `record sealed` para DTOs imutáveis quando fizer sentido.
- Use `sealed` em classes que não foram desenhadas para herança.
- Prefira injeção de dependência padrão do ASP.NET Core.
- Não concentre regras de negócio complexas em `Program.cs`.
- Em MVPs, `Program.cs` pode conter endpoints simples, mas extraia classes se a skill `clean-project-structure` indicar necessidade.
- Separe responsabilidades quando houver lógica suficiente para justificar.
- Evite criar camadas desnecessárias apenas por formalidade.
- Não exponha entidades internas diretamente como contrato público de API quando houver risco de acoplamento.
- Evite colocar lógica de negócio diretamente em endpoints HTTP quando a regra tiver complexidade relevante.
- Evite criar pastas como `Services`, `Helpers` ou `Managers` sem justificativa de domínio ou arquitetura.

---

### Assincronismo

- Use `async/await` para operações I/O-bound.
- Métodos assíncronos devem terminar com `Async`.
- Propague `CancellationToken` quando disponível.
- Não use `.Result` ou `.Wait()` em Tasks.
- Não use `async void`, exceto em event handlers.
- Evite bloquear threads desnecessariamente.
- Não crie Tasks manuais sem necessidade clara.
- Não use `Task.Run` para esconder código bloqueante sem justificar.

---

### Null safety

- Mantenha `<Nullable>enable</Nullable>`.
- Trate payloads externos como potencialmente nulos.
- Evite usar `!` para suprimir nullability sem motivo claro.
- Prefira validações explícitas.
- Use tipos anuláveis somente quando o valor realmente puder ser nulo.
- Não assuma que campos vindos de JSON, banco, fila ou sistemas externos estarão preenchidos.
- Evite `NullReferenceException` por suposição frágil.

---

### Logs

- **Stack obrigatória**: **Serilog** com `Serilog.AspNetCore` e `Serilog.Enrichers.Thread`.
- **NÃO** usar `Serilog.Expressions` / `ExpressionTemplate`. Usar enrichers em C# para `ShortLevel` e `ShortContext`.
- Use `ILogger<T>` injetado nos componentes; o provider concreto é Serilog.
- Use structured logging com placeholders: `_logger.LogInformation("User {Id}", id)`.
- Não concatene strings em logs quando puder usar placeholders.
- Não registre secrets, tokens, senhas ou dados sensíveis.
- Logs de erro devem conter contexto suficiente para investigação.
- Logs de warning devem representar situações relevantes, não fluxo normal excessivo.
- Para eventos externos, registre origem, identificador, tipo do evento e horário quando disponíveis.
- Evite logs excessivos em loops de alto volume.
- Não faça log de payload completo se ele puder conter dados sensíveis.

#### Pattern padrão de console (referência logback)

```text
%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

#### Equivalente em Serilog (`outputTemplate`)

```text
{Timestamp:yyyy-MM-dd HH:mm:ss} [{ThreadId}] {ShortLevel} {ShortContext} - {Message:lj}{NewLine}{Exception}
```

#### Enrichers obrigatórios

```csharp
using Serilog.Core;
using Serilog.Events;

internal sealed class ShortLevelEnricher : ILogEventEnricher
{
    public void Enrich(LogEvent logEvent, ILogEventPropertyFactory pf)
    {
        var shortLevel = logEvent.Level switch
        {
            LogEventLevel.Information => "INFO ",
            LogEventLevel.Warning     => "WARN ",
            LogEventLevel.Error       => "ERROR",
            LogEventLevel.Debug       => "DEBUG",
            LogEventLevel.Verbose     => "TRACE",
            LogEventLevel.Fatal       => "FATAL",
            _                          => "UNKWN"
        };
        logEvent.AddPropertyIfAbsent(pf.CreateProperty("ShortLevel", shortLevel));
    }
}

internal sealed class ShortContextEnricher : ILogEventEnricher
{
    private const int MaxLength = 36;

    public void Enrich(LogEvent logEvent, ILogEventPropertyFactory pf)
    {
        if (!logEvent.Properties.TryGetValue("SourceContext", out var ctx))
        {
            logEvent.AddPropertyIfAbsent(pf.CreateProperty("ShortContext", string.Empty));
            return;
        }

        var raw = ctx.ToString().Trim('"');
        var truncated = raw.Length > MaxLength ? raw[^MaxLength..] : raw;
        logEvent.AddPropertyIfAbsent(pf.CreateProperty("ShortContext", truncated));
    }
}
```

#### Configuração obrigatória em `Program.cs`

```csharp
using Serilog;
using Serilog.Events;

const string LogTemplate =
    "{Timestamp:yyyy-MM-dd HH:mm:ss} [{ThreadId}] {ShortLevel} {ShortContext} - {Message:lj}{NewLine}{Exception}";

builder.Host.UseSerilog((ctx, lc) => lc
    .MinimumLevel.Information()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Information)
    .Enrich.FromLogContext()
    .Enrich.WithThreadId()
    .Enrich.With<ShortLevelEnricher>()
    .Enrich.With<ShortContextEnricher>()
    .WriteTo.Console(outputTemplate: LogTemplate));
```

Saída esperada:

```text
2026-05-05 12:34:56 [11] INFO  Program - User question: hello
```

Exemplo conceitual de uso:

`_logger.LogWarning("Evento recebido. Source: {Source}, EventId: {EventId}", source, eventId);`

---

### HTTP APIs

- Retorne status HTTP coerentes.
- Use `Results.Ok`, `Results.BadRequest`, `Results.Unauthorized`, `Results.Forbid`, `Results.NotFound` etc. em Minimal APIs.
- Valide autenticação antes de processar o payload.
- Não confie em payloads externos.
- Use `System.Text.Json`, salvo necessidade real diferente.
- Não exponha stack trace em resposta HTTP.
- Não retorne dados sensíveis.
- Para erros esperados, retorne mensagens simples e objetivas.
- Para sucesso, retorne uma resposta clara indicando o que foi processado.
- Diferencie erro de autenticação, autorização, validação e erro interno.
- Evite retornar detalhes internos de implementação para o cliente.

---

### Configuração

- Use `appsettings.json` para configurações não sensíveis.
- Use variáveis de ambiente para segredos e configurações sensíveis.
- Não grave tokens, senhas ou connection strings reais no repositório.
- Para ambientes locais, use valores de desenvolvimento claramente identificados.
- Prefira nomes de configuração claros e específicos.
- Use o padrão de configuração do ASP.NET Core quando aplicável.
- Não duplique configuração em múltiplos lugares sem necessidade.

Exemplos:

- `ASPNETCORE_ENVIRONMENT`
- `ConnectionStrings__DefaultConnection`
- `EXTERNAL_SERVICE_API_KEY`

---

### Testes em C#

- Escreva testes quando houver regra de negócio relevante.
- Prefira testes simples e focados.
- Teste casos de sucesso, erro e entrada inválida.
- Para endpoints, valide status HTTP esperado.
- Para payloads externos, teste campos ausentes ou nulos.
- Não crie testes frágeis dependentes de horário real sem controle.
- Não crie mocks desnecessários quando teste de unidade simples for suficiente.
- Não ignore testes quebrando sem explicar o motivo.

---

## Regras globais para Java

### Imports

- Nunca use wildcard imports.
- Sempre importe a classe específica.
- Não use imports desnecessários.
- Organize imports conforme padrão da IDE/projeto.

Correto:

`import java.util.List;`

`import java.util.Map;`

Incorreto:

`import java.util.*;`

---

### Nomeação

- Use PascalCase para classes, records, interfaces e enums.
- Use camelCase para métodos, variáveis locais, parâmetros e atributos.
- Use UPPER_SNAKE_CASE para constantes estáticas finais.
- Use nomes orientados ao domínio.
- Evite abreviações obscuras.
- Evite nomes genéricos como `Manager`, `Helper`, `Utils` e `Processor` quando houver nome melhor.
- Métodos devem expressar ação ou intenção.
- Tipos devem expressar conceito de domínio ou responsabilidade técnica clara.

Exemplos conceituais:

- Classe: `PaymentTransactionService`
- Método: `createTransaction`
- Variável local: `transactionId`
- Parâmetro: `transactionRequest`
- Constante: `DEFAULT_TIMEOUT_SECONDS`

---

### Organização

- A estrutura do projeto deve seguir a skill `clean-project-structure`.
- Use pacotes claros e específicos.
- Não use pacote default.
- Mantenha coesão: uma classe deve ter uma responsabilidade principal.
- Prefira classes pequenas e testáveis.
- Use `record` para DTOs imutáveis quando fizer sentido.
- Use `final` em classes, campos e variáveis quando isso melhorar clareza e imutabilidade.
- Não crie abstrações sem necessidade.
- Evite acoplamento excessivo entre camadas.
- Separe regra de negócio de transporte HTTP, mensageria ou persistência quando a skill `clean-project-structure` indicar essa separação.
- Evite criar pacotes como `service`, `helper`, `utils` ou `manager` sem justificativa de domínio ou arquitetura.
- Não organize o projeto apenas por convenção de framework; organize conforme a skill `clean-project-structure`.

---

### Assincronismo e concorrência

- Não crie threads manualmente sem necessidade.
- Prefira APIs de alto nível, como virtual threads, executors ou abstrações do framework.
- Trate timeouts e cancelamentos em chamadas externas.
- Não bloqueie fluxos reativos.
- Não use `Thread.sleep` em código de produção para controle de fluxo.
- Evite condições de corrida usando estruturas adequadas de concorrência.
- Não use concorrência para otimizar prematuramente código simples.

---

### Null safety

- Evite retornar `null` quando uma coleção vazia ou `Optional` fizer mais sentido.
- Não use `Optional` como campo de entidade ou DTO serializável.
- Valide entradas externas.
- Deixe claro quando um valor pode estar ausente.
- Evite `NullPointerException` por suposições frágeis.
- Prefira objetos imutáveis quando possível.
- Não use `Optional.get()` sem verificar presença.

---

### Logs

- Use logger da stack do projeto.
- Não use `System.out.println` em código de aplicação, exceto em exemplos ou spikes explicitamente solicitados.
- Use logs estruturados quando suportado.
- Não registre secrets, tokens, senhas ou dados sensíveis.
- Logs devem conter contexto útil.
- Não use logs excessivos em loops de alto volume.
- Não faça log de payload completo se ele puder conter dados sensíveis.

---

### Exceptions

- Não engula exceções.
- Não use `catch (Exception e)` sem tratamento ou rethrow adequado.
- Crie exceções de domínio quando fizer sentido.
- Preserve a causa original usando exception chaining.
- Não use exceptions para fluxo normal de controle.
- Diferencie erro de domínio, erro de validação e erro técnico.
- Mensagens de erro devem ser claras e úteis.
- Não exponha detalhes internos de implementação em mensagens públicas de erro.

---

### Frameworks Java

- Para APIs novas, escolha o framework conforme contexto do projeto.
- A estrutura de pastas, packages e camadas deve seguir a skill `clean-project-structure`.
- Não use automaticamente o padrão Controller, Service e Repository apenas por estar usando Spring Boot.
- Não coloque regra de negócio diretamente no Controller.
- Não exponha entidades de banco diretamente como contrato público de API.
- Use DTOs para entrada e saída quando houver fronteira externa.
- Configure timeouts para chamadas HTTP externas.
- Use recursos do framework quando eles simplificarem o código sem acoplar indevidamente o domínio.

---

## Regras para Docker e Docker Compose

- Use imagens oficiais sempre que possível.
- Fixe tags de imagem quando o projeto exigir reprodutibilidade.
- Não use `latest` em ambientes reproduzíveis, salvo quando explicitamente solicitado.
- Use variáveis de ambiente para configuração.
- Não exponha portas desnecessárias.
- Use healthchecks para bancos de dados quando fizer sentido.
- Evite colocar segredos reais no `docker-compose.yml`.
- Nomeie serviços de forma clara.
- Em comunicação entre containers, use o nome do serviço Docker, não `localhost`.
- Não remova volumes sem autorização explícita.
- Não execute comandos destrutivos em volumes sem avisar.
- Evite imagens desnecessariamente grandes quando houver alternativa simples.
- Não adicione serviços ao compose sem explicar a necessidade.

---

## Regras para banco de dados

- Não rode migrations destrutivas sem autorização.
- Não apague tabelas, schemas ou volumes sem aprovação explícita.
- Para testes locais, use dados simulados e claramente identificados.
- Separe banco de aplicação, banco analítico e banco de configuração quando o contexto exigir.
- Evite queries sem filtro em tabelas grandes.
- Prefira migrations versionadas quando o projeto tiver persistência própria.
- Não coloque credenciais reais em arquivos versionados.
- Não altere estrutura de dados sem avaliar compatibilidade.
- Não faça truncates, drops ou deletes massivos sem confirmação explícita.

---

## Regras de segurança

- Trate todo input externo como não confiável.
- Valide autenticação antes de processar dados sensíveis ou ações importantes.
- Não exponha tokens em logs.
- Não exponha payloads completos se eles puderem conter dados sensíveis.
- Use HTTPS em produção.
- Para MVP local, tokens simples podem ser usados, desde que claramente identificados como locais.
- Não adicione autenticação complexa sem necessidade do escopo.
- Não armazene segredos no código-fonte.
- Não gere chaves, tokens ou senhas reais em exemplos.
- Não reduza segurança existente sem autorização explícita.

---

## Regras de testes e validação

Sempre que possível, após alterações:

- Rode build do projeto.
- Rode testes existentes.
- Informe comandos executados e resultados.
- Se não foi possível rodar testes, explique o motivo.
- Para APIs, forneça exemplo de `curl` ou HTTP request.
- Para Docker, forneça comando de subida e validação.
- Não declare que algo foi validado se o comando não foi executado.
- Diferencie claramente validação feita de validação sugerida.
- Não ignore falhas de build ou teste.
- Quando houver erro, explique a causa provável e próximo passo.

Comandos comuns:

`dotnet build`

`dotnet test`

`mvn test`

`gradle test`

`docker compose up --build`

`docker compose down`

---

## Regras para documentação

- Atualize documentação quando alterar forma de execução.
- Documente variáveis de ambiente relevantes.
- Inclua exemplos de uso quando ajudar na validação.
- Não crie documentação longa sem necessidade.
- Prefira instruções objetivas e executáveis.
- Quando houver endpoints, documente método HTTP, rota, autenticação e exemplo de payload.
- Quando houver Docker Compose, documente como subir, parar e validar.
- Não documente comportamento que não foi implementado.
- Diferencie claramente requisito, implementação e sugestão futura.

---

## Regras para prompts e interação

- Quando eu pedir modo plano, não altere arquivos até eu aprovar.
- Quando a tarefa for ambígua, faça perguntas objetivas antes de implementar.
- Quando houver múltiplas soluções possíveis, apresente alternativas com trade-offs.
- Quando eu pedir algo específico, não amplie o escopo sem avisar.
- Quando encontrar inconsistência entre arquivos, explique antes de modificar.
- Quando não conseguir validar algo, diga claramente.
- Não afirme que executou comando se não executou.
- Não afirme que leu arquivo se não leu.

---

## Definition of Done global

Uma tarefa só deve ser considerada concluída quando:

- O código compila, quando aplicável.
- Os testes existentes foram executados, quando aplicável.
- O cenário principal pode ser validado.
- Há instruções claras de execução.
- As regras deste arquivo foram respeitadas.
- Foram informados os arquivos alterados.
- Foram informados os comandos executados.
- Foi informado claramente o que não pôde ser validado, caso algo não tenha sido validado.
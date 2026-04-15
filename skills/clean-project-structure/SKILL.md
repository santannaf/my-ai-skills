---
name: clean-project-structure
description: padronizar a estrutura de diretórios e as responsabilidades de projetos java e kotlin com spring boot 4.0.5, seguindo separação por camadas (entrypoint, config, usecases, entities, providers, dataproviders, exceptions). use quando eu pedir para criar um novo projeto java/kotlin, revisar arquitetura, organizar pastas, definir boundaries, ou explicar onde cada classe/interface deve ficar seguindo este padrão.
---

# Objetivo
Garantir que **toda aplicação Java ou Kotlin** nasça com a estrutura base:

```text
santannaf.<my_project>/
  <my_project>/
    dataproviders/
    providers/
    usecases/
    entities/
    config/
    entrypoint/
    exceptions/
```

> Regra de ouro: **dependências apontam para dentro**. Regras de negócio não dependem de framework web, banco, mensageria ou SDKs externos.

---

# Escopo desta skill
Esta skill deve ser aplicada **somente** para projetos **Java** ou **Kotlin**, preferencialmente usando **Spring Boot 4.0.5**.

Não usar exemplos em:
- TypeScript
- Node.js
- Python
- NestJS
- Express

Todos os exemplos de código, nomes de classes e sugestões de estrutura devem priorizar:
- **Java** ou **Kotlin**
- **Spring Boot 4.0.5**
- organização compatível com aplicações enterprise

---

# Regra de idioma — OBRIGATÓRIO

**Todo código deve ser escrito em inglês**, sem exceção:

- Nomes de classes
- Nomes de métodos
- Nomes de variáveis
- Nomes de pacotes
- Mensagens de log
- Comentários técnicos em código

Exemplos corretos:
```java
// ✅ CORRETO
public class CreateProductUseCase {
    private static final Logger log = LoggerFactory.getLogger(CreateProductUseCase.class);

    public Product execute(CreateProductRequest request) {
        log.info("Creating product with name: {}", request.name());
        // business logic
    }
}
```

Exemplos proibidos:
```java
// ❌ PROIBIDO
public class CriarProdutoUseCase {
    public Produto executar(CriarProdutoRequest requisicao) {
        log.info("Criando produto com nome: {}", requisicao.nome());
    }
}
```

Esta regra se aplica a **todos os diretórios**: `entities/`, `usecases/`, `providers/`, `dataproviders/`, `entrypoint/`, `config/` e `exceptions/`.

---

# Estrutura base
Exemplo de package root:

```text
santannaf.<my_project>
```

Exemplo de árvore:

```text
src/main/java/santannaf/<my_project>/
  dataproviders/
  providers/
  usecases/
  entities/
  config/
  entrypoint/
  exceptions/
```

Ou em Kotlin:

```text
src/main/kotlin/santannaf/<my_project>/
  dataproviders/
  providers/
  usecases/
  entities/
  config/
  entrypoint/
  exceptions/
```

---

# Glossário (o que é cada diretório)

## `entities/` (Domain: rich entities)
**O que é:** modelos do domínio com comportamento, invariantes e regras próprias do negócio.

**Contém:**
- Entities
- Value Objects
- regras e validações de domínio
- comportamento de negócio que pertence à própria entidade

**Exemplos em Java/Kotlin:**
- `Product`
- `Order`
- `Customer`
- `Money`

**Não contém:**
- anotações de controller
- código de client HTTP
- acesso a banco
- dependência de framework web

**Depende de:** nada externo, idealmente.

---

## `usecases/` (Application: use cases)
**O que é:** classes que orquestram o fluxo de negócio da aplicação.

**Contém:**
- casos de uso como:
  - `CreateProductUseCase`
  - `GetAllProductsUseCase`
  - `UpdateCustomerLimitUseCase`
- validações de aplicação
- orquestração entre entidades e providers

**Anotação obrigatória: `@Named`**

Toda classe de use case **deve** ser anotada com `@Named` do pacote `jakarta.inject`, declarado via:

```groovy
implementation 'jakarta.inject:jakarta.inject-api:2.0.1'
```

Isso elimina a necessidade de classes `@Configuration` para registrar beans de use case.

**Exemplo em Java:**
```java
import jakarta.inject.Named;

@Named
public class CreateProductUseCase {

    private final SaveProductProvider saveProductProvider;

    public CreateProductUseCase(SaveProductProvider saveProductProvider) {
        this.saveProductProvider = saveProductProvider;
    }

    public Product execute(CreateProductRequest request) {
        var product = new Product(request.name(), request.price());
        return saveProductProvider.save(product);
    }
}
```

**Exemplo em Kotlin:**
```kotlin
import jakarta.inject.Named

@Named
class CreateProductUseCase(
    private val saveProductProvider: SaveProductProvider
) {
    fun execute(request: CreateProductRequest): Product {
        val product = Product(request.name, request.price)
        return saveProductProvider.save(product)
    }
}
```

**Não contém:**
- repositório concreto
- `RestClient`, `WebClient`, `JdbcTemplate`, `JpaRepository`, SDKs, filas
- detalhes de infraestrutura

**Depende de:**
- `entities/`
- `providers/`
- `exceptions/`

---

## `providers/` (Ports / interfaces)
**O que é:** diretório contendo **todas as interfaces** que serão implementadas pelos componentes de infraestrutura em `dataproviders/`.

**Contém:**
- contratos segregados por responsabilidade
- interfaces pequenas, específicas e coesas

**Exemplos:**
- `GetAllProductsProvider`
- `SaveProductProvider`
- `FindCustomerByIdProvider`
- `SendOrderCreatedEventProvider`

**Objetivo:** seguir principalmente o **ISP** do SOLID, evitando interfaces gigantes.

**Não contém:**
- implementação concreta
- código dependente de tecnologia específica

**Depende de:**
- `entities/` quando necessário

---

## `dataproviders/` (Infrastructure: implementations)
**O que é:** implementações concretas das interfaces definidas em `providers/`.

**Subdiretórios esperados:**
```text
dataproviders/
  repository/<my_database>/
  client/http/
  async/producer/
```

**Exemplos:**
- `dataproviders/repository/postgres/ProductRepositoryDataProvider`
- `dataproviders/repository/mysql/CustomerRepositoryDataProvider`
- `dataproviders/client/http/PricingHttpDataProvider`
- `dataproviders/async/producer/OrderCreatedProducerDataProvider`

**Contém:**
- comunicação com banco
- comunicação HTTP
- publicação assíncrona
- tradução entre modelos externos e entidades internas

**Pode usar:**
- Spring Data
- JPA
- RestClient / WebClient
- mensageria
- clients de terceiros

**Não contém:**
- regra de negócio
- decisão funcional de domínio

**Regra importante:** `dataproviders/` implementa infraestrutura, nunca o coração do negócio.

### Anotações obrigatórias por tipo de implementação

Cada classe dentro de `dataproviders/` deve ser anotada de acordo com sua responsabilidade de infraestrutura:

| Subdiretório | Finalidade | Anotação obrigatória |
|---|---|---|
| `repository/` | Acesso a banco de dados relacional | `@Repository` |
| `client/http/` | Chamadas HTTP a serviços externos | `@Service` |
| `async/producer/` | Publicação de eventos/mensagens | `@Component` |
| outros (jobs, schedulers, etc.) | Demais componentes de infraestrutura | `@Component` |

**Exemplo — acesso a banco (`@Repository`):**
```java
import org.springframework.stereotype.Repository;

@Repository
public class PostgresProductRepositoryDataProvider implements SaveProductProvider, GetAllProductsProvider {

    private final ProductJpaRepository jpaRepository;

    public PostgresProductRepositoryDataProvider(ProductJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Product save(Product product) {
        return jpaRepository.save(product);
    }

    @Override
    public List<Product> findAll() {
        return jpaRepository.findAll();
    }
}
```

**Exemplo — chamada HTTP (`@Service`):**
```java
import org.springframework.stereotype.Service;

@Service
public class PricingHttpDataProvider implements GetProductPriceProvider {

    private final RestClient restClient;

    public PricingHttpDataProvider(RestClient restClient) {
        this.restClient = restClient;
    }

    @Override
    public BigDecimal getPrice(String productId) {
        return restClient.get()
            .uri("/prices/{id}", productId)
            .retrieve()
            .body(BigDecimal.class);
    }
}
```

**Exemplo — producer de mensagens (`@Component`):**
```java
import org.springframework.stereotype.Component;

@Component
public class OrderCreatedProducerDataProvider implements SendOrderCreatedEventProvider {

    private final KafkaTemplate<String, OrderCreatedEvent> kafkaTemplate;

    public OrderCreatedProducerDataProvider(KafkaTemplate<String, OrderCreatedEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    @Override
    public void send(Order order) {
        kafkaTemplate.send("order.created", new OrderCreatedEvent(order.id(), order.total()));
    }
}
```

**Exemplos em Kotlin:**
```kotlin
// Banco de dados
@Repository
class PostgresProductRepositoryDataProvider(
    private val jpaRepository: ProductJpaRepository
) : SaveProductProvider, GetAllProductsProvider {

    override fun save(product: Product): Product = jpaRepository.save(product)
    override fun findAll(): List<Product> = jpaRepository.findAll()
}

// HTTP
@Service
class PricingHttpDataProvider(
    private val restClient: RestClient
) : GetProductPriceProvider {

    override fun getPrice(productId: String): BigDecimal =
        restClient.get()
            .uri("/prices/{id}", productId)
            .retrieve()
            .body(BigDecimal::class.java)!!
}

// Producer / mensageria
@Component
class OrderCreatedProducerDataProvider(
    private val kafkaTemplate: KafkaTemplate<String, OrderCreatedEvent>
) : SendOrderCreatedEventProvider {

    override fun send(order: Order) {
        kafkaTemplate.send("order.created", OrderCreatedEvent(order.id, order.total))
    }
}
```

---

## `config/` (Configuration and composition)
**O que é:** classes responsáveis por registrar beans, configurar clientes, factories e composição das dependências da aplicação.

**Contém:**
- classes `@Configuration`
- definição de beans singleton para infraestrutura
- configuração de clients HTTP
- configuração de datasource

> ⚠️ **Beans de use case NÃO devem ser registrados aqui.** Use cases são registrados automaticamente via `@Named` em `usecases/`. A `config/` é reservada para configuração de infraestrutura e clientes externos.

**Exemplos:**
- `HttpClientConfig`
- `DatabaseConfig`

---

## `entrypoint/` (Application entry points)
**O que é:** onde o mundo externo entra na aplicação.

**Subdiretórios esperados:**
```text
entrypoint/
  controller/api/
  consumer/
```

**Contém:**
- REST controllers
- consumers de fila
- handlers de entrada
- classes de request/response, se o projeto optar por colocá-las próximas do ponto de entrada

**Exemplos:**
- `entrypoint/controller/api/ProductController`
- `entrypoint/consumer/OrderCreatedConsumer`

**Responsabilidade:**
1. receber input
2. validar formato e campos obrigatórios
3. chamar `usecases/`
4. converter resposta para o protocolo de saída

**Não contém:**
- regra de negócio
- acesso direto ao banco
- chamadas diretas para clients externos, salvo casos muito excepcionais e técnicos

---

## `exceptions/` (Application exceptions)
**O que é:** exceções de negócio e exceções de aplicação.

**Contém:**
- `ProductNotFoundException`
- `InvalidProductPriceException`
- `CustomerLimitExceededException`
- uma exceção base como `BusinessException`, se fizer sentido

**Objetivo:** centralizar as exceções sem espalhar regras pela aplicação.

**Não contém:**
- exceções específicas de bibliotecas de banco ou HTTP como regra principal do domínio

---

# Regras de dependência (obrigatórias)

- `entities/` não depende de nenhum outro diretório
- `usecases/` depende de `entities/`, `providers/` e `exceptions/`
- `providers/` depende de `entities/` quando necessário
- `dataproviders/` implementa `providers/` e pode depender de Spring, JPA, HTTP, mensageria e banco
- `entrypoint/` chama `usecases/`
- `config/` conecta infraestrutura (não beans de use case — estes usam `@Named`)
- `exceptions/` pode ser usado por `entities/` e `usecases/`

Checklist:
- `UseCase` conhece interface, não implementação concreta
- `UseCase` é anotado com `@Named` do `jakarta.inject`
- `Controller` chama `UseCase`, não `dataprovider`
- `DataProvider` implementa interface de `providers/`
- `DataProvider` em `repository/` é anotado com `@Repository`
- `DataProvider` em `client/http/` é anotado com `@Service`
- `DataProvider` em `async/`, jobs e demais infra são anotados com `@Component`
- `Entity` não sabe o que é controller, banco, mensageria ou client HTTP
- Nomes de classes, métodos, variáveis, pacotes e logs estão em inglês

---

# Padrões de nomes (recomendado)

## Interfaces em `providers/`
- `GetAllProductsProvider`
- `SaveProductProvider`
- `FindOrderByIdProvider`

## Casos de uso em `usecases/`
- `CreateProductUseCase`
- `GetAllProductsUseCase`
- `ApprovePaymentUseCase`

## Implementações em `dataproviders/`
- `PostgresGetAllProductsDataProvider`
- `HttpPricingDataProvider`
- `KafkaOrderEventDataProvider`

## Entradas em `entrypoint/`
- `ProductController`
- `CustomerController`
- `OrderCreatedConsumer`

---

# Exemplo de árvore em Java com Spring Boot 4.0.5

```text
src/main/java/santannaf/catalog/
  entities/
    Product.java
    Money.java
  exceptions/
    ProductNotFoundException.java
    InvalidPriceException.java
  providers/
    GetAllProductsProvider.java
    SaveProductProvider.java
  usecases/
    GetAllProductsUseCase.java      ← @Named
    CreateProductUseCase.java       ← @Named
  dataproviders/
    repository/postgres/
      ProductRepositoryDataProvider.java    ← @Repository
    client/http/
      PricingHttpDataProvider.java          ← @Service
    async/producer/
      ProductEventProducerDataProvider.java ← @Component
  entrypoint/
    controller/api/
      ProductController.java
    consumer/
      ProductCreatedConsumer.java
  config/
    HttpClientConfig.java
    DatabaseConfig.java
```

> Não há `UseCaseConfig.java` — os use cases são registrados automaticamente via `@Named`.

---

# Exemplo de árvore em Kotlin com Spring Boot 4.0.5

```text
src/main/kotlin/santannaf/catalog/
  entities/
    Product.kt
    Money.kt
  exceptions/
    ProductNotFoundException.kt
    InvalidPriceException.kt
  providers/
    GetAllProductsProvider.kt
    SaveProductProvider.kt
  usecases/
    GetAllProductsUseCase.kt        ← @Named
    CreateProductUseCase.kt         ← @Named
  dataproviders/
    repository/postgres/
      ProductRepositoryDataProvider.kt     ← @Repository
    client/http/
      PricingHttpDataProvider.kt           ← @Service
    async/producer/
      ProductEventProducerDataProvider.kt  ← @Component
  entrypoint/
    controller/api/
      ProductController.kt
    consumer/
      ProductCreatedConsumer.kt
  config/
    HttpClientConfig.kt
    DatabaseConfig.kt
```

> Não há `UseCaseConfig.kt` — os use cases são registrados automaticamente via `@Named`.

---

# Dependência obrigatória para `@Named`

Adicionar ao `build.gradle` (Gradle) ou `pom.xml` (Maven):

**Gradle:**
```groovy
implementation 'jakarta.inject:jakarta.inject-api:2.0.1'
```

**Maven:**
```xml
<dependency>
    <groupId>jakarta.inject</groupId>
    <artifactId>jakarta.inject-api</artifactId>
    <version>2.0.1</version>
</dependency>
```

---

# Como Claude deve responder usando esta skill

Quando for pedido para criar, revisar ou organizar um projeto Java/Kotlin:

1. assumir **Java ou Kotlin** como linguagens válidas
2. priorizar **Spring Boot 4.0.5**
3. gerar a árvore base neste padrão
4. dizer exatamente onde cada classe deve ficar
5. apontar violações arquiteturais quando mostrar código ou estrutura existente
6. responder com exemplos em **Java** ou **Kotlin**, nunca em TypeScript
7. **todo código deve estar em inglês**: classes, métodos, variáveis, pacotes e logs
8. **todo use case deve usar `@Named`** do `jakarta.inject:jakarta.inject-api:2.0.1`
9. **não criar `UseCaseConfig`** — o `@Named` substitui esse bean manual
10. **toda implementação em `dataproviders/` deve ter a anotação correta**: `@Repository` para banco, `@Service` para HTTP, `@Component` para os demais

---

# Anti-padrões (proibidos)

- `usecases/` importando `JpaRepository`, `WebClient`, `RestClient`, `JdbcTemplate`, client de fila ou SDK externo
- `entrypoint/` chamando `dataproviders/` diretamente
- `dataproviders/` contendo regra de negócio
- `entities/` dependendo de framework web
- interfaces enormes em `providers/`
- exemplos em TypeScript, Node ou Python
- **código em português**: nomes de classes, métodos, variáveis, pacotes ou logs em português são uma violação
- **use case sem `@Named`**: toda classe de use case deve ser anotada com `@Named`
- **`UseCaseConfig`**: classe de configuração para registrar beans de use case não deve existir quando `@Named` está disponível
- **`@Component` em classe de repositório**: classe em `dataproviders/repository/` deve usar `@Repository`, não `@Component`
- **`@Repository` em client HTTP**: classe em `dataproviders/client/http/` deve usar `@Service`, não `@Repository`
- **anotação ausente em `dataproviders/`**: toda implementação concreta em `dataproviders/` deve carregar uma das anotações obrigatórias (`@Repository`, `@Service` ou `@Component`)

---

# Nota final
Este padrão deve ser usado como base para projetos **Java e Kotlin com Spring Boot 4.0.5**.  
Se módulos adicionais forem necessários, como `dto/`, `mapper/`, `presenter/` ou `validator/`, eles podem ser sugeridos como extensão, mas os diretórios base nunca devem ser removidos.  
Todo código produzido deve estar em **inglês**, todo use case deve carregar a anotação **`@Named`** do `jakarta.inject`, e toda implementação em `dataproviders/` deve ser anotada com **`@Repository`**, **`@Service`** ou **`@Component`** conforme sua responsabilidade de infraestrutura.
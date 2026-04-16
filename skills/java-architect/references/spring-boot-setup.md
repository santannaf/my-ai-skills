# Spring Boot Setup

## Overview

This reference defines the standard project structure for **Java** or **Kotlin** applications using **Spring Boot 4.0.5**, following the `clean-project-structure` skill.

The project must follow this package root pattern:

```text
santannaf.<my_project>
```

The default architectural rule is:

> Dependencies point inward. Business rules must not depend on web frameworks, databases, messaging, or external SDKs.

---

## Base Project Structure

### Java

```text
src/main/java/santannaf/<my_project>/
  dataproviders/
    repository/
      postgres/
    client/
      http/
    async/
      producer/
  providers/
  usecases/
  entities/
  config/
  entrypoint/
    controller/
      api/
    consumer/
  exceptions/
```

### Kotlin

```text
src/main/kotlin/santannaf/<my_project>/
  dataproviders/
    repository/
      postgres/
    client/
      http/
    async/
      producer/
  providers/
  usecases/
  entities/
  config/
  entrypoint/
    controller/
      api/
    consumer/
  exceptions/
```

---

## Language Rule

All code must be written in **English**, without exception.

This includes:
- package names
- class names
- method names
- variable names
- log messages
- technical comments in code

Examples:

```java
public class CreateProductUseCase {

    public Product execute(CreateProductRequest request) {
        return new Product(request.name(), request.price());
    }
}
```

Incorrect:

```java
public class CriarProdutoUseCase {

    public Produto executar(CriarProdutoRequest requisicao) {
        return new Produto(requisicao.nome(), requisicao.preco());
    }
}
```

---

## Layer Responsibilities

### `entities/`

Domain models with business behavior, invariants, and validation rules.

Contains:
- entities
- value objects
- domain validations
- business behavior that belongs to the entity itself

Does not contain:
- controllers
- repository implementations
- HTTP clients
- messaging adapters
- web framework annotations

Depends on:
- ideally nothing external

---

### `usecases/`

Application use cases responsible for orchestrating business flow.

Contains:
- `CreateProductUseCase`
- `GetAllProductsUseCase`
- `ApprovePaymentUseCase`

Rules:
- must depend only on `entities/`, `providers/`, and `exceptions/`
- must be annotated with `@Named`
- must not import `JpaRepository`, `RestClient`, `WebClient`, `JdbcTemplate`, messaging clients, or external SDKs

#### Mandatory annotation

Every use case must use `@Named` from `jakarta.inject`.

```java
import jakarta.inject.Named;

@Named
public class CreateProductUseCase {
}
```

Required dependency:

### Gradle

```groovy
implementation 'jakarta.inject:jakarta.inject-api:2.0.1'
```

### Maven

```xml
<dependency>
    <groupId>jakarta.inject</groupId>
    <artifactId>jakarta.inject-api</artifactId>
    <version>2.0.1</version>
</dependency>
```

---

### `providers/`

Interfaces used as ports by the use cases.

Contains:
- `SaveProductProvider`
- `GetAllProductsProvider`
- `FindCustomerByIdProvider`
- `SendOrderCreatedEventProvider`

Rules:
- interfaces must be small and cohesive
- no concrete implementation here
- may depend on `entities/` when needed

---

### `dataproviders/`

Concrete infrastructure implementations of `providers/`.

Expected subdirectories:

```text
dataproviders/
  repository/postgres/
  client/http/
  async/producer/
```

Contains:
- database access
- HTTP integrations
- message publishing
- translation between external models and internal entities

Rules:
- must not contain business rules
- infrastructure only

#### Mandatory annotations by type

| Subdirectory         | Purpose                      | Mandatory annotation |
|----------------------|------------------------------|----------------------|
| `repository/`        | relational database access   | `@Repository`        |
| `client/http/`       | external HTTP calls          | `@Service`           |
| `async/producer/`    | event/message publishing     | `@Component`         |
| other infrastructure | schedulers, jobs, listeners  | `@Component`         |

---

### `config/`

Infrastructure configuration and bean composition.

Contains:
- `@Configuration`
- datasource configuration
- HTTP client beans
- OpenAPI configuration
- external client factories

Rules:
- do not register use cases here
- use cases must be registered automatically via `@Named`
- do not create `UseCaseConfig`

---

### `entrypoint/`

External input layer.

Expected subdirectories:

```text
entrypoint/
  controller/api/
  consumer/
```

Contains:
- REST controllers
- queue consumers
- protocol input handlers
- request/response models when the project chooses to keep them near the entrypoint

Responsibilities:
1. receive input
2. validate required fields and format
3. call `usecases/`
4. convert response to the external protocol

Does not contain:
- business rules
- direct database access
- direct infrastructure orchestration outside exceptional technical cases

---

### `exceptions/`

Application and business exceptions.

Contains:
- `BusinessException`
- `ProductNotFoundException`
- `InvalidPriceException`
- `CustomerLimitExceededException`

Rules:
- centralize business and application exceptions here
- should not be dominated by framework-specific exceptions

---

## Dependency Rules

- `entities/` must not depend on any other project layer
- `usecases/` depends on `entities/`, `providers/`, and `exceptions/`
- `providers/` may depend on `entities/`
- `dataproviders/` implements `providers/` and may depend on Spring, JPA, HTTP, messaging, and database technologies
- `entrypoint/` calls `usecases/`
- `config/` wires infrastructure only
- `exceptions/` may be used by `entities/` and `usecases/`

### Checklist

- `UseCase` knows interfaces, not concrete implementations
- every `UseCase` is annotated with `@Named`
- `Controller` calls `UseCase`, not `DataProvider`
- `DataProvider` implements interfaces from `providers/`
- repository data providers use `@Repository`
- HTTP data providers use `@Service`
- async and other infra data providers use `@Component`
- `Entity` does not know controller, database, messaging, or HTTP client concepts
- all code is written in English

---

## Naming Conventions

### Interfaces in `providers/`
- `GetAllProductsProvider`
- `SaveProductProvider`
- `FindOrderByIdProvider`

### Use cases in `usecases/`
- `CreateProductUseCase`
- `GetAllProductsUseCase`
- `ApprovePaymentUseCase`

### Implementations in `dataproviders/`
- `PostgresGetAllProductsDataProvider`
- `HttpPricingDataProvider`
- `KafkaOrderEventDataProvider`

### Entry points in `entrypoint/`
- `ProductController`
- `CustomerController`
- `OrderCreatedConsumer`

---

## Example Project Tree

### Java Example

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
    GetAllProductsUseCase.java
    CreateProductUseCase.java
  dataproviders/
    repository/postgres/
      ProductRepositoryDataProvider.java
    client/http/
      PricingHttpDataProvider.java
    async/producer/
      ProductEventProducerDataProvider.java
  entrypoint/
    controller/api/
      ProductController.java
    consumer/
      ProductCreatedConsumer.java
  config/
    HttpClientConfig.java
    DatabaseConfig.java
    OpenApiConfig.java
```

### Kotlin Example

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
    GetAllProductsUseCase.kt
    CreateProductUseCase.kt
  dataproviders/
    repository/postgres/
      ProductRepositoryDataProvider.kt
    client/http/
      PricingHttpDataProvider.kt
    async/producer/
      ProductEventProducerDataProvider.kt
  entrypoint/
    controller/api/
      ProductController.kt
    consumer/
      ProductCreatedConsumer.kt
  config/
    HttpClientConfig.kt
    DatabaseConfig.kt
    OpenApiConfig.kt
```

---

## Build Files

This reference prioritizes **Spring Boot 4.0.5**.

### Gradle (`build.gradle`)

```groovy
plugins {
    id 'java'
    id 'org.springframework.boot' version '4.0.5'
    id 'io.spring.dependency-management' version '1.1.7'
}

group = 'santannaf'
version = '1.0.0'

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-actuator'

    implementation 'jakarta.inject:jakarta.inject-api:2.0.1'

    implementation 'org.flywaydb:flyway-core'
    runtimeOnly 'org.postgresql:postgresql'

    implementation 'org.springdoc:springdoc-openapi-starter-webmvc-ui:2.8.9'

    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.testcontainers:junit-jupiter'
    testImplementation 'org.testcontainers:postgresql'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

### Gradle Kotlin DSL (`build.gradle.kts`)

```kotlin
plugins {
    java
    id("org.springframework.boot") version "4.0.5"
    id("io.spring.dependency-management") version "1.1.7"
}

group = "santannaf"
version = "1.0.0"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(25))
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-actuator")

    implementation("jakarta.inject:jakarta.inject-api:2.0.1")

    implementation("org.flywaydb:flyway-core")
    runtimeOnly("org.postgresql:postgresql")

    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.8.9")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.testcontainers:junit-jupiter")
    testImplementation("org.testcontainers:postgresql")
}

tasks.test {
    useJUnitPlatform()
}
```

### Maven (`pom.xml`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>4.0.5</version>
        <relativePath/>
    </parent>

    <groupId>santannaf</groupId>
    <artifactId>catalog</artifactId>
    <version>1.0.0</version>
    <name>catalog</name>
    <description>Catalog service</description>

    <properties>
        <java.version>25</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>

        <dependency>
            <groupId>jakarta.inject</groupId>
            <artifactId>jakarta.inject-api</artifactId>
            <version>2.0.1</version>
        </dependency>

        <dependency>
            <groupId>org.flywaydb</groupId>
            <artifactId>flyway-core</artifactId>
        </dependency>

        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>

        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
            <version>2.8.9</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>junit-jupiter</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>postgresql</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

---

## Application Configuration

### `application.yml`

```yaml
spring:
  application:
    name: catalog

  datasource:
    url: ${DATABASE_URL:jdbc:postgresql://localhost:5432/catalog}
    username: ${DATABASE_USER:catalog}
    password: ${DATABASE_PASSWORD:catalog}

  jpa:
    hibernate:
      ddl-auto: validate
    open-in-view: false

  flyway:
    enabled: true
    baseline-on-migrate: true
    locations: classpath:db/migration

server:
  port: 8080
  shutdown: graceful
  error:
    include-message: always
    include-binding-errors: always

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

---

## Main Application Class

```java
package santannaf.catalog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CatalogApplication {
    static void main(String[] args) {
        SpringApplication.run(CatalogApplication.class, args);
    }
}
```

---

## Code Examples

### Entity Example

```java
package santannaf.catalog.entities;

import java.math.BigDecimal;
import java.util.UUID;

public class Product {

    private final UUID id;
    private final String name;
    private final BigDecimal price;

    public Product(String name, BigDecimal price) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Product name must not be blank");
        }
        if (price == null || price.signum() < 0) {
            throw new IllegalArgumentException("Product price must not be negative");
        }

        this.id = UUID.randomUUID();
        this.name = name;
        this.price = price;
    }

    public UUID id() {
        return id;
    }

    public String name() {
        return name;
    }

    public BigDecimal price() {
        return price;
    }
}
```

### Provider Example

```java
package santannaf.catalog.providers;

import santannaf.catalog.entities.Product;

public interface SaveProductProvider {
    Product save(Product product);
}
```

### Use Case Example

```java
package santannaf.catalog.usecases;

import jakarta.inject.Named;
import santannaf.catalog.entities.Product;
import santannaf.catalog.providers.SaveProductProvider;

import java.math.BigDecimal;

@Named
public class CreateProductUseCase {

    private final SaveProductProvider saveProductProvider;

    public CreateProductUseCase(SaveProductProvider saveProductProvider) {
        this.saveProductProvider = saveProductProvider;
    }

    public Product execute(CreateProductRequest request) {
        Product product = new Product(request.name(), request.price());
        return saveProductProvider.save(product);
    }

    public record CreateProductRequest(String name, BigDecimal price) {
    }
}
```

### Repository Data Provider Example

```java
package santannaf.catalog.dataproviders.repository.postgres;

import org.springframework.stereotype.Repository;
import santannaf.catalog.entities.Product;
import santannaf.catalog.providers.SaveProductProvider;

@Repository
public class PostgresProductRepositoryDataProvider implements SaveProductProvider {

    @Override
    public Product save(Product product) {
        return product;
    }
}
```

### HTTP Data Provider Example

```java
package santannaf.catalog.dataproviders.client.http;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;

@Service
public class PricingHttpDataProvider {

    private final RestClient restClient;

    public PricingHttpDataProvider(RestClient restClient) {
        this.restClient = restClient;
    }

    public BigDecimal getPrice(String productId) {
        return restClient.get()
            .uri("/prices/{id}", productId)
            .retrieve()
            .body(BigDecimal.class);
    }
}
```

### Async Data Provider Example

```java
package santannaf.catalog.dataproviders.async.producer;

import org.springframework.stereotype.Component;

@Component
public class ProductEventProducerDataProvider {

    public void sendCreatedEvent(String productId) {
        // send message to broker
    }
}
```

### REST Controller Example

```java
package santannaf.catalog.entrypoint.controller.api;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import santannaf.catalog.entities.Product;
import santannaf.catalog.usecases.CreateProductUseCase;

import java.math.BigDecimal;

@RestController
@RequestMapping("/products")
public class ProductController {

    private final CreateProductUseCase createProductUseCase;

    public ProductController(CreateProductUseCase createProductUseCase) {
        this.createProductUseCase = createProductUseCase;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Product create(@Valid @RequestBody CreateProductRequest request) {
        return createProductUseCase.execute(
            new CreateProductUseCase.CreateProductRequest(request.name(), request.price())
        );
    }

    public record CreateProductRequest(
        @NotBlank String name,
        @DecimalMin("0.0") BigDecimal price
    ) {
    }
}
```

---

## Configuration Examples

### `config/HttpClientConfig.java`

```java
package santannaf.catalog.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class HttpClientConfig {

    @Bean
    public RestClient restClient(RestClient.Builder builder) {
        return builder.build();
    }
}
```

### `config/OpenApiConfig.java`

```java
package santannaf.catalog.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Catalog API")
                .version("1.0.0")
                .description("Enterprise API for catalog operations"));
    }
}
```

---

## Exception Handling

### `exceptions/ProductNotFoundException.java`

```java
package santannaf.catalog.exceptions;

public class ProductNotFoundException extends RuntimeException {

    public ProductNotFoundException(String message) {
        super(message);
    }
}
```

### `config/GlobalExceptionHandler.java`

```java
package santannaf.catalog.config;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import santannaf.catalog.exceptions.ProductNotFoundException;

import java.time.Instant;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ProductNotFoundException.class)
    public ProblemDetail handleNotFound(ProductNotFoundException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.NOT_FOUND,
            ex.getMessage()
        );
        problem.setProperty("timestamp", Instant.now());
        return problem;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidation(MethodArgumentNotValidException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.BAD_REQUEST,
            "Validation failed"
        );
        problem.setProperty(
            "errors",
            ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .toList()
        );
        problem.setProperty("timestamp", Instant.now());
        return problem;
    }
}
```

---

## Anti-Patterns

The following is forbidden in this structure:

- `usecases/` importing `JpaRepository`, `WebClient`, `RestClient`, `JdbcTemplate`, messaging clients, or external SDKs
- `entrypoint/` calling `dataproviders/` directly
- `dataproviders/` containing business rules
- `entities/` depending on web framework annotations
- large and generic interfaces in `providers/`
- code written in Portuguese
- use case classes without `@Named`
- `UseCaseConfig` classes for manual use case registration
- repository data providers annotated with `@Component` instead of `@Repository`
- HTTP data providers annotated with `@Repository` instead of `@Service`
- missing annotations in concrete classes under `dataproviders/`

---

## Quick Reference

| Component        | Responsibility                                     |
|------------------|----------------------------------------------------|
| `entities/`      | Domain models and invariants                       |
| `usecases/`      | Business flow orchestration                        |
| `providers/`     | Application ports and contracts                    |
| `dataproviders/` | Infrastructure implementations                     |
| `config/`        | Infrastructure configuration                       |
| `entrypoint/`    | External input layer                               |
| `exceptions/`    | Business and application exceptions                |
| `@Named`         | Mandatory for use cases                            |
| `@Repository`    | Mandatory for database data providers              |
| `@Service`       | Mandatory for HTTP data providers                  |
| `@Component`     | Mandatory for async and other infra data providers |

---

## Final Notes

This structure is the default standard for **Java** and **Kotlin** projects using **Spring Boot 4.0.5**.

Additional folders such as `dto/`, `mapper/`, `validator/`, or `presenter/` may be added when necessary, but the base folders must remain:

- `dataproviders/`
- `providers/`
- `usecases/`
- `entities/`
- `config/`
- `entrypoint/`
- `exceptions/`

Use cases must always use `@Named`, infrastructure implementations in `dataproviders/` must always use the correct Spring stereotype annotation, and all code must always be written in English.

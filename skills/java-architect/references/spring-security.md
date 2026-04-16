# Spring Security Setup

## Objective

Standardize security in **Java applications with Spring Boot 4.0.5** using the project structure defined by `clean-project-structure`, with the following principles:

- **stateless authentication**
- **JWE tokens only** for access tokens
- **password hashing with Argon2 + unique salt + application pepper**
- **no plaintext password storage**
- **no password generation as a substitute for hashing**
- **controllers calling use cases only**
- **all code written in English**
- **Java 25 supported by Spring Boot 4.0.5**

Spring Boot 4.0.5 is officially available, and its documented system requirements state compatibility up to and including **Java 26**, which covers Java 25. citeturn809298search0turn809298search16

---

## Mandatory Project Structure

```text
src/main/java/santannaf/<my_project>/
  dataproviders/
    repository/
      postgres/
    client/
      http/
  providers/
  usecases/
  entities/
  config/
  entrypoint/
    controller/
      api/
  exceptions/
  security/
    filter/
    model/
```

> `security/` is an acceptable extension module for cross-cutting security concerns such as token services, authentication filters, security models, and cryptographic helpers. The base directories from the skill must remain present.

---

## Layer Responsibilities

### `entities/`
Contains rich domain models and business invariants.

Examples:
- `User`
- `Role`
- `Permission`

Rules:
- must not depend on Spring MVC, Spring Security, JPA repositories, HTTP clients, or messaging SDKs
- may hold domain-level validation and invariants

---

### `usecases/`
Contains application business flows.

Examples:
- `LoginUserUseCase`
- `RegisterUserUseCase`
- `RefreshTokenUseCase`

Rules:
- must use `@Named`
- must depend only on `entities/`, `providers/`, `exceptions/`, and, when truly necessary, security abstractions
- must not import `JpaRepository`, `JdbcTemplate`, `WebClient`, `RestClient`, queue clients, or external SDKs directly

> **Do not annotate use cases with `@Service`** when following the `clean-project-structure` pattern. Use `@Named` instead.

---

### `providers/`
Contains application ports used by use cases.

Examples:
- `UserProvider`
- `SaveUserProvider`
- `TokenServiceProvider`
- `PasswordHashProvider`

Rules:
- interfaces only
- small, cohesive contracts
- no infrastructure logic

---

### `dataproviders/`
Contains infrastructure implementations.

Examples:
- `dataproviders/repository/postgres/PostgresUserRepositoryDataProvider`
- `dataproviders/client/http/IdentityHttpDataProvider`

Rules:
- repository implementations: `@Repository`
- HTTP client implementations: `@Service`
- other infrastructure components: `@Component`
- no business rules here

---

### `entrypoint/`
Contains API entry points.

Examples:
- `entrypoint/controller/api/AuthController`

Responsibilities:
1. receive input
2. validate transport-level fields
3. invoke use cases
4. convert the result to HTTP responses

Rules:
- controllers must not call `dataproviders/` directly
- controllers must not hash passwords, generate tokens, or perform credential verification

---

### `config/`
Contains only infrastructure and framework configuration.

Examples:
- `SecurityConfig`
- `CorsConfig`
- `CryptoConfig`

Rules:
- no use case bean registration here
- use cases are discovered via `@Named`

---

### `exceptions/`
Contains business and application exceptions.

Examples:
- `InvalidCredentialsException`
- `UserNotFoundException`
- `TokenValidationException`

---

### `security/`
Contains cross-cutting security implementation details.

Examples:
- `security/JweTokenService`
- `security/filter/JweAuthenticationFilter`
- `security/model/AuthenticatedUser`

Rules:
- may depend on Spring Security and cryptography libraries
- should not become a place for domain business rules

---

## Dependency Rules

- `entities/` must not depend on other layers
- `usecases/` depends on `entities/`, `providers/`, and `exceptions/`
- `providers/` may depend on `entities/`
- `dataproviders/` implements `providers/`
- `entrypoint/` calls `usecases/`
- `config/` wires framework and infrastructure only
- `security/` may be used by config and infrastructure; use cases should depend on abstractions, not framework-heavy details, whenever possible

---

## Security Model

This reference standardizes the following model:

### 1. Password storage
Passwords must be **hashed**, never encrypted.

Recommended approach:
- **Argon2id** as the password hashing algorithm
- **unique random salt per password**
- **application pepper** stored outside the database, typically in environment variables or a secrets manager
- constant-time verification path as much as possible

Important:
- **Salt is not a private key**
- **Pepper is the application secret**
- **Passwords should not be “generated” to improve security**; they should be securely hashed and verified

Your provided login flow already follows a strong pattern by appending a pepper before Argon2 verification and computing a dummy verification path to reduce timing-based username enumeration. That is a meaningful improvement over the older BCrypt-based reference. fileciteturn0file0L1-L35

### 2. Authentication token
Access tokens must be **JWE-encrypted**, not only signed JWTs.

Recommended approach:
- `RSA-OAEP-256` for key management
- `A256GCM` for content encryption
- short expiration windows
- key material externalized in production

### 3. Stateless API security
Recommended for REST APIs:
- `SessionCreationPolicy.STATELESS`
- custom bearer filter for JWE validation
- CSRF disabled only when the API is genuinely stateless and not session/browser-driven

Spring Security documents stateless session management as a supported pattern, and its reference also notes that disabling CSRF is generally appropriate for non-browser or fully stateless service APIs. citeturn809298search3turn809298search17

---

## Recommended Package Example

```text
src/main/java/santannaf/read/pdf/readpdf/
  entities/
    User.java
  exceptions/
    InvalidCredentialsException.java
  providers/
    UserProvider.java
    TokenServiceProvider.java
    PasswordHashProvider.java
  usecases/
    LoginUserUseCase.java
  dataproviders/
    repository/postgres/
      PostgresUserRepositoryDataProvider.java
  security/
    JweTokenService.java
    filter/
      JweAuthenticationFilter.java
    model/
      AuthenticatedUser.java
  config/
    SecurityConfig.java
    CryptoConfig.java
  entrypoint/
    controller/api/
      AuthController.java
    data/
      request/
        LoginRequest.java
      response/
        AuthResponse.java
```

---

## Build Configuration

Spring Boot 4.0.5 is the recommended version in this reference. The official system requirements also document support for **Maven 3.6.3+** and **Gradle 8.14+ or 9.x**. citeturn809298search2turn809298search16

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
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-actuator'

    implementation 'jakarta.inject:jakarta.inject-api:2.0.1'

    implementation 'de.mkammerer:argon2-jvm:2.12'
    implementation 'com.nimbusds:nimbus-jose-jwt:10.3'

    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.security:spring-security-test'
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
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-actuator")

    implementation("jakarta.inject:jakarta.inject-api:2.0.1")

    implementation("de.mkammerer:argon2-jvm:2.12")
    implementation("com.nimbusds:nimbus-jose-jwt:10.3")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
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
    <artifactId>secure-service</artifactId>
    <version>1.0.0</version>

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
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
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
            <groupId>de.mkammerer</groupId>
            <artifactId>argon2-jvm</artifactId>
            <version>2.12</version>
        </dependency>

        <dependency>
            <groupId>com.nimbusds</groupId>
            <artifactId>nimbus-jose-jwt</artifactId>
            <version>10.3</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
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
app:
  security:
    pepper: ${APP_SECURITY_PEPPER}
    jwe:
      token-expiry-hours: 24
      public-key-pem: ${APP_SECURITY_JWE_PUBLIC_KEY_PEM:}
      private-key-pem: ${APP_SECURITY_JWE_PRIVATE_KEY_PEM:}

  cors:
    allowed-origins: ${APP_CORS_ALLOWED_ORIGINS:http://localhost:3000}

spring:
  application:
    name: secure-service

server:
  port: 8080
  shutdown: graceful

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### Notes

- `pepper` must come from environment variables or a secrets manager, never from source control
- production systems should externalize the RSA key pair used for JWE
- generating a fresh RSA key pair at startup is acceptable for local development only because it invalidates all tokens on restart

Your provided `JweTokenService` already documents this trade-off correctly by warning that startup-generated keys invalidate tokens across restarts. That is a good development default but not a production default. fileciteturn0file0L37-L82

---

## Main Application Class

```java
package santannaf.secureservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SecureServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(SecureServiceApplication.class, args);
    }
}
```

---

## Password Hashing Standard

### Rules

- use **Argon2id**
- use **unique random salt per password**
- append or combine the **pepper** before hashing
- store only the resulting Argon2 hash string
- never store the raw password
- never store the pepper in the database
- verify with the same pepper path
- optionally perform dummy verification when the user is missing

### Recommended provider abstraction

```java
package santannaf.secureservice.providers;

public interface PasswordHashProvider {

    String hash(char[] rawPassword);

    boolean verify(String storedHash, char[] rawPassword);

    boolean verifyDummy(char[] rawPassword);
}
```

### Recommended Argon2 implementation

```java
package santannaf.secureservice.security;

import de.mkammerer.argon2.Argon2;
import de.mkammerer.argon2.Argon2Factory;
import jakarta.annotation.PreDestroy;
import java.nio.charset.StandardCharsets;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import santannaf.secureservice.providers.PasswordHashProvider;

@Component
public class Argon2PasswordHashProvider implements PasswordHashProvider {

    private final Argon2 argon2;
    private final String pepper;
    private final String dummyHash;

    public Argon2PasswordHashProvider(@Value("${app.security.pepper}") String pepper) {
        this.argon2 = Argon2Factory.create(Argon2Factory.Argon2Types.ARGON2id);
        this.pepper = pepper;
        this.dummyHash = argon2.hash(20, 65536, 2,
                ("__dummy__" + pepper).toCharArray(),
                StandardCharsets.UTF_8);
    }

    @Override
    public String hash(char[] rawPassword) {
        return argon2.hash(20, 65536, 2,
                combineWithPepper(rawPassword),
                StandardCharsets.UTF_8);
    }

    @Override
    public boolean verify(String storedHash, char[] rawPassword) {
        return argon2.verify(storedHash, combineWithPepper(rawPassword));
    }

    @Override
    public boolean verifyDummy(char[] rawPassword) {
        return argon2.verify(dummyHash, combineWithPepper(rawPassword));
    }

    private char[] combineWithPepper(char[] rawPassword) {
        return (new String(rawPassword) + pepper).toCharArray();
    }

    @PreDestroy
    public void destroy() {
        argon2.wipeArray("__cleanup__".toCharArray());
    }
}
```

### Important note

The Argon2 encoded hash already includes the **salt** and Argon2 parameters. The application should store the encoded Argon2 output as-is.

---

## Login Use Case Pattern

Use case classes must follow the architectural pattern from the skill.

### Correct version with `@Named`

```java
package santannaf.secureservice.usecases;

import jakarta.inject.Named;
import java.util.Optional;
import santannaf.secureservice.entities.User;
import santannaf.secureservice.entrypoint.data.request.LoginRequest;
import santannaf.secureservice.entrypoint.data.response.AuthResponse;
import santannaf.secureservice.exceptions.InvalidCredentialsException;
import santannaf.secureservice.providers.PasswordHashProvider;
import santannaf.secureservice.providers.TokenServiceProvider;
import santannaf.secureservice.providers.UserProvider;

@Named
public class LoginUserUseCase {

    private final UserProvider userProvider;
    private final PasswordHashProvider passwordHashProvider;
    private final TokenServiceProvider tokenServiceProvider;

    public LoginUserUseCase(
            UserProvider userProvider,
            PasswordHashProvider passwordHashProvider,
            TokenServiceProvider tokenServiceProvider) {
        this.userProvider = userProvider;
        this.passwordHashProvider = passwordHashProvider;
        this.tokenServiceProvider = tokenServiceProvider;
    }

    public AuthResponse execute(LoginRequest request) {
        Optional<User> userOpt = userProvider.findByEmail(request.email());

        if (userOpt.isEmpty()) {
            passwordHashProvider.verifyDummy(request.password().toCharArray());
            throw new InvalidCredentialsException();
        }

        User user = userOpt.get();
        boolean matches = passwordHashProvider.verify(
                user.passwordHash(),
                request.password().toCharArray());

        if (!matches) {
            throw new InvalidCredentialsException();
        }

        String token = tokenServiceProvider.generateAccessToken(user.id(), user.email());
        return new AuthResponse(token, user.id().toString(), user.email(), user.name());
    }
}
```

### Why this shape is preferred

- `usecases/` depends on interfaces, not concrete crypto/token classes
- `@Named` matches the project architecture skill
- timing equalization remains preserved through `verifyDummy`
- the use case stays focused on orchestration

---

## Token Service Standard

### Provider abstraction

```java
package santannaf.secureservice.providers;

import java.util.UUID;

public interface TokenServiceProvider {

    String generateAccessToken(UUID userId, String email);
}
```

### JWE implementation

```java
package santannaf.secureservice.security;

import com.nimbusds.jose.EncryptionMethod;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWEAlgorithm;
import com.nimbusds.jose.JWEHeader;
import com.nimbusds.jose.crypto.RSADecrypter;
import com.nimbusds.jose.crypto.RSAEncrypter;
import com.nimbusds.jwt.EncryptedJWT;
import com.nimbusds.jwt.JWTClaimsSet;
import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;
import org.springframework.stereotype.Service;
import santannaf.secureservice.providers.TokenServiceProvider;

@Service
public class JweTokenService implements TokenServiceProvider {

    private static final String CLAIM_EMAIL = "email";

    @Override
    public String generateAccessToken(UUID userId, String email) {
        try {
            JWTClaimsSet claims = new JWTClaimsSet.Builder()
                    .subject(userId.toString())
                    .claim(CLAIM_EMAIL, email)
                    .issueTime(new Date())
                    .expirationTime(Date.from(Instant.now().plus(24, ChronoUnit.HOURS)))
                    .build();

            JWEHeader header = new JWEHeader.Builder(
                    JWEAlgorithm.RSA_OAEP_256,
                    EncryptionMethod.A256GCM)
                    .contentType("JWT")
                    .build();

            EncryptedJWT jwt = new EncryptedJWT(header, claims);
            jwt.encrypt(new RSAEncrypter(loadPublicKey()));
            return jwt.serialize();
        } catch (JOSEException ex) {
            throw new IllegalStateException("Failed to generate access token", ex);
        }
    }

    public JWTClaimsSet validateAndExtract(String token) {
        try {
            EncryptedJWT jwt = EncryptedJWT.parse(token);
            jwt.decrypt(new RSADecrypter(loadPrivateKey()));

            JWTClaimsSet claims = jwt.getJWTClaimsSet();
            Date expiry = claims.getExpirationTime();
            if (expiry == null || expiry.before(new Date())) {
                throw new SecurityException("Token has expired");
            }
            return claims;
        } catch (ParseException | JOSEException ex) {
            throw new SecurityException("Invalid token", ex);
        }
    }

    private java.security.interfaces.RSAPublicKey loadPublicKey() {
        throw new UnsupportedOperationException("Load RSA public key from externalized configuration");
    }

    private java.security.interfaces.RSAPrivateKey loadPrivateKey() {
        throw new UnsupportedOperationException("Load RSA private key from externalized configuration");
    }
}
```

### Production recommendation

- keep the RSA key pair outside the application image
- use environment variables, mounted secrets, or a secret manager
- support rotation strategy when possible
- avoid generating a new key pair on every startup in production

---

## Security Configuration Pattern

Spring Security provides the core architecture for servlet authentication and authorization, and a custom bearer filter approach fits into that model for stateless APIs. citeturn809298search5turn809298search15

### `config/SecurityConfig.java`

```java
package santannaf.secureservice.config;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import santannaf.secureservice.security.filter.JweAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true)
public class SecurityConfig {

    private final JweAuthenticationFilter jweAuthenticationFilter;
    private final List<String> allowedOrigins;

    public SecurityConfig(
            JweAuthenticationFilter jweAuthenticationFilter,
            @Value("${app.cors.allowed-origins:*}") String allowedOriginsRaw) {
        this.jweAuthenticationFilter = jweAuthenticationFilter;
        this.allowedOrigins = Arrays.stream(allowedOriginsRaw.split(","))
                .map(String::trim)
                .filter(value -> !value.isBlank())
                .collect(Collectors.toList());
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/register", "/auth/login").permitAll()
                        .requestMatchers("/actuator/health").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(jweAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        if (allowedOrigins.contains("*")) {
            config.setAllowedOriginPatterns(List.of("*"));
        } else {
            config.setAllowedOrigins(allowedOrigins);
        }
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
```

### Notes

- use `allowedOriginPatterns` only when wildcard support is explicitly intended
- prefer explicit origins in production
- permit only the endpoints that must be public

Your provided configuration already follows several solid stateless security defaults: explicit public endpoints, stateless sessions, CORS centralization, and a custom filter placed before `UsernamePasswordAuthenticationFilter`. fileciteturn0file0L84-L147

---

## Authentication Filter Pattern

```java
package santannaf.secureservice.security.filter;

import com.nimbusds.jwt.JWTClaimsSet;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import santannaf.secureservice.security.JweTokenService;

@Component
public class JweAuthenticationFilter extends OncePerRequestFilter {

    private final JweTokenService jweTokenService;

    public JweAuthenticationFilter(JweTokenService jweTokenService) {
        this.jweTokenService = jweTokenService;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        try {
            JWTClaimsSet claims = jweTokenService.validateAndExtract(token);
            String subject = claims.getSubject();
            String email = claims.getStringClaim("email");

            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                            email,
                            null,
                            List.of(new SimpleGrantedAuthority("ROLE_USER"))
                    );

            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (Exception ex) {
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }
}
```

---

## Controller Pattern

```java
package santannaf.secureservice.entrypoint.controller.api;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import santannaf.secureservice.entrypoint.data.request.LoginRequest;
import santannaf.secureservice.entrypoint.data.response.AuthResponse;
import santannaf.secureservice.usecases.LoginUserUseCase;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final LoginUserUseCase loginUserUseCase;

    public AuthController(LoginUserUseCase loginUserUseCase) {
        this.loginUserUseCase = loginUserUseCase;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(loginUserUseCase.execute(request));
    }
}
```

---

## Recommended Anti-Patterns to Avoid

### Passwords
- using BCrypt as the default reference when the project standard is Argon2
- storing plaintext passwords
- treating encryption as password storage
- omitting pepper when your security standard requires it
- sharing one static salt across all users

### Tokens
- using signed-only JWT as the default reference when the project standard requires JWE
- generating ephemeral RSA keys in production
- using long-lived access tokens without justification

### Architecture
- annotating `usecases/` classes with `@Service` instead of `@Named`
- making use cases depend directly on `JweTokenService` or repository implementations when an interface should be used
- calling providers or repositories directly from controllers
- putting business logic inside filters

### Language and consistency
- Portuguese class, method, variable, comment, or log names
- mixed architecture styles in the same reference

One mismatch between your current security code and the `clean-project-structure` standard is that the provided `LoginUserUseCase` is annotated with `@Service`; under your architectural rule set, it should move to `usecases/` and use `@Named` instead. fileciteturn0file0L1-L35

---

## Quick Reference

| Component                         | Responsibility                                                    |
|-----------------------------------|-------------------------------------------------------------------|
| `@EnableWebSecurity`              | Enable Spring Security web integration                            |
| `@EnableMethodSecurity`           | Enable method-level authorization                                 |
| `SecurityFilterChain`             | Configure HTTP security                                           |
| `SessionCreationPolicy.STATELESS` | Disable server session usage                                      |
| `OncePerRequestFilter`            | Custom bearer token filter                                        |
| `@Named`                          | Mandatory annotation for use cases                                |
| `Argon2id`                        | Password hashing algorithm                                        |
| `salt`                            | Per-password random value embedded in the Argon2 output           |
| `pepper`                          | Application secret kept outside the database                      |
| `JWE`                             | Encrypted token payload                                           |
| `@Repository`                     | Database infrastructure component                                 |
| `@Service`                        | HTTP infrastructure component or dedicated service implementation |
| `@Component`                      | Generic infrastructure implementation                             |

---

## Recommended Final Standard

For this project family, the preferred baseline is:

- **Spring Boot 4.0.5**
- **Java 25**
- **Spring Security with stateless API configuration**
- **Argon2id + unique salt + application pepper** for password hashing
- **JWE tokens** for authenticated requests
- **externalized RSA key pair in production**
- **`@Named` use cases in `usecases/`**
- **providers as interfaces, dataproviders as implementations**
- **all code in English**

This replaces the previous reference that was centered on BCrypt, signed JWT, `UserDetailsService`, and a layer model incompatible with your current architectural skill. The old reference content you shared is useful as a baseline for generic Spring Security features, but it does not match your required security posture or your directory rules. fileciteturn0file0L1-L35

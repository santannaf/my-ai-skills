# Security - Spring Security 7

## Objective

Standardize security in Java applications using **Spring Boot 4.0.5**, **Spring Security 7**, **Java 25**, and the project structure defined by the `clean-project-structure` skill.

This reference adopts the following principles:

- **Stateless authentication**
- **JWE token encryption** instead of plain signed JWT as the default application token model
- **Argon2** for password hashing
- **Salt + pepper** for password hashing
- **Use cases in `usecases/` annotated with `@Named`**
- **Security configuration in `config/`**
- **Security filters and token services as infrastructure components**
- **All code in English**

> Important: passwords must never be "encrypted" for later recovery. They must be **hashed** using **Argon2** with **unique salt per password** and an application-level **pepper** stored outside the database.

---

## Package Structure

```text
src/main/java/santannaf/<my_project>/
  entities/
  usecases/
  providers/
  dataproviders/
    repository/
      postgres/
    client/
      http/
    async/
      producer/
  config/
  entrypoint/
    controller/
      api/
  exceptions/
  security/
  filter/
```

> `security/` and `filter/` are acceptable support packages for technical security components such as token services and servlet filters. They are infrastructure-oriented and must not contain business rules.

---

## Responsibilities by Layer

### `entities/`
Contains domain models only.

Examples:
- `User`
- `Role`
- `Permission`

Rules:
- no controller annotations
- no repository implementation
- no HTTP client logic
- no Spring Security framework behavior inside domain entities unless strictly needed as plain domain data

---

### `usecases/`
Contains authentication and authorization flows as application logic.

Examples:
- `LoginUserUseCase`
- `RegisterUserUseCase`
- `RefreshTokenUseCase`
- `ChangePasswordUseCase`

Rules:
- must use `@Named`
- must depend on `providers/`, `entities/`, and `exceptions/`
- must not depend directly on JPA repositories or HTTP clients

Example:

```java
package santannaf.catalog.usecases;

import de.mkammerer.argon2.Argon2;
import jakarta.inject.Named;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import santannaf.catalog.entities.User;
import santannaf.catalog.entrypoint.data.request.LoginRequest;
import santannaf.catalog.entrypoint.data.response.AuthResponse;
import santannaf.catalog.exceptions.InvalidCredentialsException;
import santannaf.catalog.providers.UserProvider;
import santannaf.catalog.security.JweTokenService;

@Named
public class LoginUserUseCase {

    private final UserProvider userProvider;
    private final Argon2 argon2;
    private final JweTokenService tokenService;
    private final String pepperKey;
    private final String dummyHash;

    public LoginUserUseCase(
            UserProvider userProvider,
            Argon2 argon2,
            JweTokenService tokenService,
            SecurityProperties securityProperties) {
        this.userProvider = userProvider;
        this.argon2 = argon2;
        this.tokenService = tokenService;
        this.pepperKey = securityProperties.pepper();
        this.dummyHash = argon2.hash(
                securityProperties.argon2Iterations(),
                securityProperties.argon2MemoryKiB(),
                securityProperties.argon2Parallelism(),
                ("__dummy__" + pepperKey).toCharArray(),
                StandardCharsets.UTF_8
        );
    }

    public AuthResponse login(LoginRequest request) {
        Optional<User> userOpt = userProvider.findByEmail(request.email());
        String storedHash = userOpt.map(User::passwordHash).orElse(dummyHash);

        boolean matches = argon2.verify(storedHash, (request.password() + pepperKey).toCharArray());

        if (userOpt.isEmpty() || !matches) {
            throw new InvalidCredentialsException();
        }

        User user = userOpt.get();
        String token = tokenService.generateToken(user.id(), user.email());
        return new AuthResponse(token, user.id().toString(), user.email(), user.name());
    }
}
```

---

### `providers/`
Contains application ports.

Examples:
- `UserProvider`
- `SaveUserProvider`
- `FindUserByEmailProvider`

Example:

```java
package santannaf.catalog.providers;

import java.util.Optional;
import santannaf.catalog.entities.User;

public interface UserProvider {
    Optional<User> findByEmail(String email);
}
```

---

### `dataproviders/`
Contains concrete infrastructure implementations.

Examples:
- `dataproviders/repository/postgres/PostgresUserDataProvider`
- `dataproviders/client/http/IdentityHttpDataProvider`

Rules:
- repository implementations must use `@Repository`
- HTTP clients must use `@Service`
- async/event components must use `@Component`
- no business rules here

Example:

```java
package santannaf.catalog.dataproviders.repository.postgres;

import java.util.Optional;
import org.springframework.stereotype.Repository;
import santannaf.catalog.entities.User;
import santannaf.catalog.providers.UserProvider;

@Repository
public class PostgresUserDataProvider implements UserProvider {

    private final UserJpaRepository userJpaRepository;

    public PostgresUserDataProvider(UserJpaRepository userJpaRepository) {
        this.userJpaRepository = userJpaRepository;
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userJpaRepository.findByEmail(email).map(UserEntityMapper::toDomain);
    }
}
```

---

### `config/`
Contains Spring Security, hashing, CORS, and HTTP security setup.

Examples:
- `SecurityConfig`
- `SecurityPropertiesConfig`
- `CorsConfig`

---

### `entrypoint/`
Contains controllers only.

Examples:
- `entrypoint/controller/api/AuthController`

Rules:
- controllers call use cases
- controllers must not call repository implementations directly

---

### `exceptions/`
Contains business and application security exceptions.

Examples:
- `InvalidCredentialsException`
- `InvalidTokenException`
- `ExpiredTokenException`
- `UserAlreadyExistsException`

---

## Security Model

This standard uses:

1. **Argon2** to hash passwords
2. **Unique salt per password** generated by Argon2 and embedded in the stored hash
3. **Pepper** stored in external configuration or secret management
4. **JWE encrypted token** for authenticated requests
5. **Stateless API** with `SessionCreationPolicy.STATELESS`
6. **Security filter** that extracts and validates Bearer JWE tokens

### Password hashing rule

The password flow must be:

```text
raw password + pepper -> Argon2 hash with unique salt -> stored hash
```

### Why this matters

- **Salt** defeats rainbow tables and ensures equal passwords do not produce equal hashes
- **Pepper** adds an additional secret outside the database
- **Argon2** is memory-hard and designed for password hashing
- **JWE** encrypts claims instead of leaving them only signed and readable

---

## Security Configuration

```java
package santannaf.catalog.config;

import de.mkammerer.argon2.Argon2;
import de.mkammerer.argon2.Argon2Factory;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
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
import santannaf.catalog.filter.JweAuthenticationFilter;
import santannaf.catalog.security.JweTokenService;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JweTokenService tokenService;
    private final List<String> allowedOrigins;

    public SecurityConfig(
            JweTokenService tokenService,
            @Value("${app.cors.allowed-origins:*}") String allowedOriginsRaw) {
        this.tokenService = tokenService;
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
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/register", "/auth/login").permitAll()
                        .requestMatchers("/actuator/health").permitAll()
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(
                        new JweAuthenticationFilter(tokenService),
                        UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        if (allowedOrigins.contains("*")) {
            configuration.setAllowedOriginPatterns(List.of("*"));
        } else {
            configuration.setAllowedOrigins(allowedOrigins);
        }

        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public Argon2 argon2() {
        return Argon2Factory.create();
    }
}
```

---

## JWE Token Service

```java
package santannaf.catalog.security;

import com.nimbusds.jose.EncryptionMethod;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWEAlgorithm;
import com.nimbusds.jose.JWEHeader;
import com.nimbusds.jose.crypto.RSADecrypter;
import com.nimbusds.jose.crypto.RSAEncrypter;
import com.nimbusds.jose.jwk.KeyUse;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jose.jwk.gen.RSAKeyGenerator;
import com.nimbusds.jwt.EncryptedJWT;
import com.nimbusds.jwt.JWTClaimsSet;
import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JweTokenService {

    private static final String CLAIM_EMAIL = "email";

    private final RSAKey rsaKey;
    private final long tokenExpiryHours;

    public JweTokenService(
            @Value("${app.security.jwe.key-size:2048}") int keySize,
            @Value("${app.security.jwe.token-expiry-hours:24}") long tokenExpiryHours)
            throws JOSEException {
        this.rsaKey = new RSAKeyGenerator(keySize)
                .keyUse(KeyUse.ENCRYPTION)
                .keyID(UUID.randomUUID().toString())
                .generate();
        this.tokenExpiryHours = tokenExpiryHours;
    }

    public String generateToken(UUID userId, String email) {
        try {
            JWTClaimsSet claims = new JWTClaimsSet.Builder()
                    .subject(userId.toString())
                    .claim(CLAIM_EMAIL, email)
                    .issueTime(new Date())
                    .expirationTime(Date.from(Instant.now().plus(tokenExpiryHours, ChronoUnit.HOURS)))
                    .build();

            JWEHeader header = new JWEHeader.Builder(JWEAlgorithm.RSA_OAEP_256, EncryptionMethod.A256GCM)
                    .contentType("JWT")
                    .build();

            EncryptedJWT jwt = new EncryptedJWT(header, claims);
            jwt.encrypt(new RSAEncrypter(rsaKey.toRSAPublicKey()));
            return jwt.serialize();
        } catch (JOSEException exception) {
            throw new IllegalStateException("Failed to generate JWE token", exception);
        }
    }

    public JWTClaimsSet validateAndExtract(String token) throws JOSEException, ParseException {
        EncryptedJWT jwt = EncryptedJWT.parse(token);
        jwt.decrypt(new RSADecrypter(rsaKey.toRSAPrivateKey()));

        JWTClaimsSet claims = jwt.getJWTClaimsSet();
        Date expiration = claims.getExpirationTime();

        if (expiration == null || expiration.before(new Date())) {
            throw new SecurityException("Token has expired");
        }

        return claims;
    }
}
```

> For production, the RSA key pair should be externalized to a secret manager, KMS, Vault, or environment-backed key material instead of being generated only at startup.

---

## Authentication Filter

```java
package santannaf.catalog.filter;

import com.nimbusds.jwt.JWTClaimsSet;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;
import santannaf.catalog.security.JweTokenService;

public class JweAuthenticationFilter extends OncePerRequestFilter {

    private final JweTokenService tokenService;

    public JweAuthenticationFilter(JweTokenService tokenService) {
        this.tokenService = tokenService;
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
            JWTClaimsSet claims = tokenService.validateAndExtract(token);

            if (SecurityContextHolder.getContext().getAuthentication() == null) {
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                                claims.getSubject(),
                                null,
                                java.util.List.of());

                authentication.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (ParseException | SecurityException exception) {
            SecurityContextHolder.clearContext();
        } catch (Exception exception) {
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }
}
```

---

## Password Hashing Standard

### Registration / password change flow

```java
package santannaf.catalog.usecases;

import de.mkammerer.argon2.Argon2;
import jakarta.inject.Named;
import santannaf.catalog.entities.User;
import santannaf.catalog.providers.SaveUserProvider;

@Named
public class RegisterUserUseCase {

    private final SaveUserProvider saveUserProvider;
    private final Argon2 argon2;
    private final SecurityProperties securityProperties;

    public RegisterUserUseCase(
            SaveUserProvider saveUserProvider,
            Argon2 argon2,
            SecurityProperties securityProperties) {
        this.saveUserProvider = saveUserProvider;
        this.argon2 = argon2;
        this.securityProperties = securityProperties;
    }

    public User execute(String name, String email, String rawPassword) {
        String passwordHash = argon2.hash(
                securityProperties.argon2Iterations(),
                securityProperties.argon2MemoryKiB(),
                securityProperties.argon2Parallelism(),
                (rawPassword + securityProperties.pepper()).toCharArray()
        );

        User user = new User(null, name, email, passwordHash);
        return saveUserProvider.save(user);
    }
}
```

### Important notes

- Argon2 already generates and stores the **salt** inside the resulting encoded hash
- the **pepper** must stay outside the database
- never store raw passwords
- never use reversible encryption for user passwords
- use a dummy verification path on login to reduce timing-based username enumeration

---

## Authentication Controller

```java
package santannaf.catalog.entrypoint.controller.api;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import santannaf.catalog.entrypoint.data.request.LoginRequest;
import santannaf.catalog.entrypoint.data.response.AuthResponse;
import santannaf.catalog.usecases.LoginUserUseCase;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final LoginUserUseCase loginUserUseCase;

    public AuthController(LoginUserUseCase loginUserUseCase) {
        this.loginUserUseCase = loginUserUseCase;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.status(HttpStatus.OK).body(loginUserUseCase.login(request));
    }
}
```

---

## Configuration Properties

Use `@ConfigurationProperties` for security settings instead of scattering security values across multiple `@Value` fields when possible.

```java
package santannaf.catalog.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.security")
public record SecurityProperties(
        String pepper,
        int argon2Iterations,
        int argon2MemoryKiB,
        int argon2Parallelism,
        JweProperties jwe
) {
    public record JweProperties(int keySize, long tokenExpiryHours) {
    }
}
```

```yaml
app:
  security:
    pepper: ${APP_SECURITY_PEPPER}
    argon2-iterations: 20
    argon2-memory-kib: 65536
    argon2-parallelism: 1
    jwe:
      key-size: 2048
      token-expiry-hours: 24
  cors:
    allowed-origins: http://localhost:3000
```

---

## Method Security

Method security remains valid and should be enabled through `@EnableMethodSecurity`.

Example:

```java
package santannaf.catalog.usecases;

import jakarta.inject.Named;
import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import santannaf.catalog.entities.User;
import santannaf.catalog.providers.FindAllUsersProvider;

@Named
public class GetAllUsersUseCase {

    private final FindAllUsersProvider findAllUsersProvider;

    public GetAllUsersUseCase(FindAllUsersProvider findAllUsersProvider) {
        this.findAllUsersProvider = findAllUsersProvider;
    }

    @PreAuthorize("hasRole('ADMIN')")
    public List<User> execute() {
        return findAllUsersProvider.findAll();
    }
}
```

---

## Recommended Dependencies

### Gradle

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'jakarta.inject:jakarta.inject-api:2.0.1'

    implementation 'de.mkammerer:argon2-jvm:2.12'
    implementation 'com.nimbusds:nimbus-jose-jwt:10.5'
}
```

### Maven

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
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
        <version>10.5</version>
    </dependency>
</dependencies>
```

---

## What is no longer the default in this standard

The following patterns are **not** the default for this reference:

- `BCryptPasswordEncoder` as the main password strategy
- signed JWT only with `HS256` as the main application token model
- `AuthenticationService` concentrating all flow and persistence details in one service class
- controller calling infrastructure directly
- use case annotated with `@Service` instead of `@Named`

These may still exist in other projects, but they do not match this security standard.

---

## Best Practices

- always use HTTPS in production
- keep the pepper outside the database
- prefer secret manager or KMS for RSA keys and peppers
- rotate token encryption keys safely
- implement audit logging for login failures and token errors
- protect login against brute force attacks and rate-limit authentication endpoints
- keep security events observable
- validate input strictly
- avoid exposing whether an email exists during login
- do not log raw passwords, peppers, or token contents

---

## Quick Reference

| Component                 | Purpose                                  |
|---------------------------|------------------------------------------|
| `@EnableWebSecurity`      | Enables Spring Security web support      |
| `@EnableMethodSecurity`   | Enables method-level authorization       |
| `@Named`                  | Mandatory annotation for use cases       |
| `Argon2`                  | Password hashing with salt + pepper      |
| `JweTokenService`         | JWE generation and validation            |
| `JweAuthenticationFilter` | Extracts and validates Bearer JWE tokens |
| `SecurityFilterChain`     | HTTP security rules                      |
| `@Repository`             | Repository data provider implementation  |
| `@Service`                | HTTP data provider implementation        |
| `@Component`              | Other infra implementations              |

---

## Final Standard

For this architecture, the expected default is:

- **Spring Boot 4.0.5**
- **Spring Security 7**
- **Java 25**
- **Argon2 + salt + pepper** for passwords
- **JWE encrypted token** for stateless auth
- **use cases in `usecases/` with `@Named`**
- **ports in `providers/`**
- **infra in `dataproviders/`**
- **controllers in `entrypoint/controller/api/`**
- **security config in `config/`**


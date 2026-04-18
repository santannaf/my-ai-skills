---
name: security-code-review
description: Use this skill to perform a static security review of source code, configuration, scripts, infrastructure files, and pull requests. It detects likely vulnerabilities, insecure coding patterns, exposed secrets, and risky security misconfigurations across backend, frontend, and DevOps assets, with special attention to Java and Spring Boot applications.
---

# Security Code Review

## Purpose

Use this skill when the user wants to review code for security weaknesses, insecure coding practices, dangerous APIs, exposed secrets, or application security flaws.

This skill is designed for defensive static analysis only. It reviews:
- source code
- diffs and pull requests
- configuration files
- scripts
- Docker/Kubernetes/Terraform files
- CI/CD definitions
- frontend code
- backend code
- infrastructure-related files

This skill does not execute code, exploit vulnerabilities, or perform offensive actions.

---

## When to use

Use this skill when the user asks to:
- inspect code for vulnerabilities
- find security flaws in a repository
- review a pull request from a security perspective
- scan a project for unsafe patterns
- validate whether an application is secure before release
- check for hardcoded secrets
- audit Java / Spring Boot code for security issues
- inspect frontend code for XSS and unsafe DOM usage
- review scripts or automation for injection risks

---

## What to scan

Always inspect the following areas when relevant:

### 1. Injection vulnerabilities
Look for:
- SQL injection
- command injection
- shell injection
- NoSQL injection
- LDAP injection
- XPath injection
- template injection
- header injection

Typical red flags:
- string concatenation in queries
- building commands with user input
- dynamic filters without allowlists
- direct interpolation into templates

### 2. Dynamic code execution
Look for:
- `eval(...)`
- `exec(...)`
- `new Function(...)`
- script engines
- expression evaluation with untrusted input
- dynamic class loading from untrusted sources

### 3. Cross-site scripting
Look for:
- unsanitized user input rendered into HTML
- DOM sinks such as `innerHTML` or `outerHTML`
- React `dangerouslySetInnerHTML`
- unsafe markdown rendering
- server templates with escaping disabled
- stored, reflected, and DOM-based XSS paths

### 4. Unsafe deserialization
Look for:
- Java native deserialization
- Jackson polymorphic deserialization without restriction
- Python `pickle`
- unsafe YAML loaders
- PHP `unserialize`
- untrusted serialized payload processing

### 5. OS command execution
Look for:
- `os.system`
- `subprocess(..., shell=True)`
- `Runtime.getRuntime().exec(...)`
- `ProcessBuilder`
- shell scripts using untrusted variables
- wrapper scripts invoking system commands from external input

### 6. Path traversal and unsafe file access
Look for:
- user-controlled file paths
- path concatenation with filenames from requests
- archive extraction without path validation
- arbitrary file read/write risks
- upload/download endpoints with weak path validation
- `../` traversal possibilities

### 7. Authentication flaws
Look for:
- missing authentication checks
- insecure login logic
- insecure token handling
- trusting client-supplied identity
- broken session validation
- missing verification around privileged endpoints

### 8. Authorization flaws
Look for:
- missing ownership checks
- IDOR patterns
- endpoint role checks that are missing or incomplete
- trusting frontend role information
- admin-only actions reachable by normal users
- resource access based only on request parameters

### 9. Hardcoded secrets
Look for:
- API keys
- passwords
- connection strings
- JWT secrets
- private keys
- OAuth client secrets
- credentials in YAML, properties, Dockerfiles, shell scripts, tests, or comments

### 10. Cryptographic weaknesses
Look for:
- weak algorithms such as MD5 or SHA1 where inappropriate
- hardcoded keys
- hardcoded salts or IVs
- disabled TLS verification
- insecure random generation
- homegrown crypto
- encoding presented as encryption

### 11. Sensitive data exposure
Look for:
- logs with passwords, tokens, CPF, card data, or PII
- stack traces returned to users
- verbose exception messages
- secrets exposed in frontend bundles
- internal config leaked in error responses

### 12. SSRF and outbound request abuse
Look for:
- server fetching user-supplied URLs
- webhook handlers without URL controls
- internal host access
- metadata endpoint access
- redirects or callbacks that can be repurposed into SSRF

### 13. XXE and parser abuse
Look for:
- XML parsers with dangerous defaults
- external entity resolution enabled
- unsafe parser configuration
- file disclosure through parser features

### 14. Open redirect
Look for:
- user-controlled redirect targets
- weak validation of callback URLs
- unchecked `returnUrl`, `redirect`, `next`, `continue` parameters

### 15. Race conditions and insecure state handling
Look for:
- check-then-act logic on privileged operations
- unsafe temp file creation
- multi-step state changes without locking or validation
- duplicate processing issues in payment or transfer flows

### 16. Security misconfiguration
Look for:
- debug mode enabled in production
- permissive CORS
- cookies missing `HttpOnly`, `Secure`, or `SameSite`
- missing CSRF protections when relevant
- exposed actuator/admin endpoints
- default credentials
- overly permissive container settings
- unnecessary public services

---

## How to reason during review

### Step 1. Identify trust boundaries
Map the entry points:
- HTTP request parameters
- request bodies
- headers
- cookies
- path variables
- uploaded files
- environment variables
- queue messages
- database values later rendered to users
- external services and webhooks

### Step 2. Trace untrusted data
Follow attacker-controlled data into sensitive sinks:
- SQL queries
- shell commands
- file paths
- HTML rendering
- deserializers
- redirects
- logs
- access control decisions
- outbound network requests

### Step 3. Check whether mitigation exists
Validate whether the code uses:
- parameterized queries
- prepared statements
- context-aware output encoding
- sanitization where appropriate
- allowlists
- canonical path validation
- secure secret storage
- proper authorization checks
- safe parser settings

### Step 4. Distinguish real risk from noise
Classify each issue as:
- **Confirmed**
- **Likely**
- **Suspicious / Needs manual review**

Do not overclaim exploitability if the code path is incomplete or contextual evidence is missing.

---

## How to report findings

For every finding, use this format:

### [Severity] Title
- **Category:** vulnerability category
- **Confidence:** Confirmed / Likely / Suspicious
- **Location:** file path and function/class/line if available
- **What is happening:** concise description of the insecure pattern
- **Why it is risky:** likely attacker impact
- **Attack path:** high-level explanation only, no exploit instructions
- **Recommended fix:** concrete remediation steps

At the end, add:

## Summary
- count by severity
- most urgent items first
- areas that look safe
- items needing manual validation

---

## Severity rubric

### Critical
Use when the issue may enable:
- remote code execution
- authentication bypass
- severe authorization bypass
- direct secret compromise of production credentials
- highly exploitable injection in critical paths

### High
Use when the issue may enable:
- SQL injection
- stored XSS in meaningful contexts
- unsafe deserialization of untrusted data
- SSRF with internal access potential
- command execution with realistic attacker input
- broken authorization in sensitive endpoints

### Medium
Use when:
- exploitability depends on conditions
- impact is significant but narrower
- there is meaningful risk but not immediate critical compromise

### Low
Use for:
- defense-in-depth gaps
- weaker hardening issues
- limited information exposure
- risky patterns with constrained exploitability

### Informational
Use for:
- notable hygiene concerns
- patterns worth improving
- safe code observations
- hardening suggestions without clear vulnerability

---

## Detection heuristics

### Command injection
Flag when:
- user input is concatenated into shell commands
- shell mode is enabled
- command strings are built dynamically
- scripts pass unquoted variables into commands

Examples:
- `os.system("grep " + userInput)`
- `subprocess.run("ls " + arg, shell=True)`
- `Runtime.getRuntime().exec("sh -c " + input)`

### eval / dynamic execution
Flag when:
- untrusted input reaches `eval`, `exec`, `new Function`, script engines, or dynamic runtime evaluation

### XSS
Flag when:
- user data reaches HTML or DOM sinks without escaping or sanitization
- a rich text or markdown renderer accepts unsafe HTML
- frontend directly injects attacker-controlled content into DOM sinks

### Unsafe deserialization
Flag when:
- untrusted data is deserialized into objects
- dangerous loaders or permissive polymorphic configuration is used

### Path traversal
Flag when:
- user input influences file location
- code concatenates base path + user filename
- there is no normalization plus canonical base-path validation
- archives are extracted without validating output paths

### SQL injection
Flag when:
- SQL is assembled with concatenation, interpolation, or formatting
- raw queries are constructed from request input
- dynamic sort/order/table names are accepted without strict allowlisting

### Hardcoded secrets
Flag when:
- code or configuration contains real or realistic credentials, private keys, access tokens, or secrets

---

## Java and Spring Boot specific review rules

Always apply these checks when reviewing Java or Spring Boot projects.

### 1. SQL injection in repositories and JDBC code
Look for:
- `Statement` with string concatenation
- native queries built with input
- `EntityManager.createNativeQuery(...)` using concatenated values
- dynamic JPQL/HQL from request parameters
- sort/order clauses built directly from request input

Preferred safe patterns:
- `PreparedStatement`
- parameter binding
- controlled allowlists for sortable fields

### 2. Command execution
Look for:
- `Runtime.getRuntime().exec(...)`
- `ProcessBuilder(...)`
- shell wrappers
- external tool invocation based on request data

Treat as high risk when request parameters, headers, DB data, or file names influence command parts.

### 3. Unsafe deserialization
Look for:
- `ObjectInputStream`
- native Java serialization
- Spring endpoints accepting serialized blobs
- Jackson default typing or polymorphic binding without strict type control

Review carefully:
- `enableDefaultTyping`
- permissive subtype handling
- deserializing untrusted JSON into broad object graphs

### 4. Spring MVC / REST controller authz gaps
Look for:
- controllers missing authorization for sensitive actions
- trusting `userId` or `role` from request body
- missing ownership checks in `/users/{id}`, `/accounts/{id}`, `/orders/{id}`
- business rules relying only on frontend restrictions

Examples:
- delete/update endpoints using path variable `id` without checking principal ownership
- admin operations protected only in UI, not server-side

### 5. Spring Security misconfiguration
Look for:
- overly broad `permitAll()`
- missing authentication on sensitive routes
- disabled CSRF on session-based apps without justification
- insecure password encoders
- custom filters that trust unsigned data
- insecure remember-me setup
- JWT validation flaws

Review:
- `SecurityFilterChain`
- method security annotations
- exception handling that leaks internals

### 6. Sensitive actuator exposure
Look for:
- actuator endpoints exposed publicly
- `/env`, `/beans`, `/mappings`, `/heapdump`, `/loggers`, `/configprops`
- admin interfaces accessible without auth
- health endpoints leaking detailed internals

Check:
- `management.endpoints.web.exposure.include`
- whether access is restricted

### 7. Hardcoded secrets in `application.yml` / `application.properties`
Look for:
- DB passwords
- JWT secrets
- API keys
- SMTP credentials
- cloud credentials
- signing keys

Prefer:
- environment variables
- vault/secret manager integration
- externalized secure config

### 8. File upload and download risks
Look for:
- `MultipartFile` saved using original filename directly
- file download path built from request parameter
- missing content-type or extension validation
- unrestricted file uploads
- path traversal in file retrieval endpoints

### 9. SpEL and template risks
Look for:
- Spring Expression Language evaluation from user input
- dynamic expressions in security or template logic
- Thymeleaf rendering of unescaped content
- template fragments populated with unsafe HTML

### 10. Redirect handling
Look for:
- controllers returning `redirect:` with user input
- callback URLs used without allowlisting
- login success/failure redirects based on request parameter

### 11. Logging leaks
Look for:
- request bodies logged blindly
- authentication tokens logged
- CPF, email, secret, or card data in logs
- exception logging that includes credentials or full connection strings

### 12. Validation gaps
Look for:
- missing bean validation on DTOs
- controllers accepting broad maps instead of typed DTOs
- weak validation of enum-like inputs such as `sort`, `direction`, `status`, `role`

### 13. Transaction and business logic abuse
Look for:
- transfer/payment flows missing idempotency
- race conditions in balance updates
- check-then-update logic without transaction or locking
- inconsistent authorization inside service layer

### 14. CORS and cookie security
Look for:
- wildcard origins in sensitive apps
- credentials allowed broadly
- cookies missing secure flags
- insecure session settings

### 15. Error handling and information disclosure
Look for:
- stack traces in API responses
- debug details in production
- custom exception handlers returning internal class names or SQL messages

---

## Java / Spring Boot hotspots to inspect first

Prioritize these files:
- controllers
- security configuration
- service layer for authorization checks
- repositories and custom queries
- DTO binding layers
- file upload/download handlers
- config classes
- exception handlers
- actuator config
- `application.yml`
- `application.properties`
- Dockerfiles
- CI/CD secrets
- webhook consumers
- payment/transfer/account flows

---

## Frontend review rules

When frontend code is present, inspect for:
- XSS sinks
- token storage in localStorage/sessionStorage
- unsafe HTML rendering
- secrets shipped in bundle
- open redirects
- insecure fetch usage
- missing CSRF handling in session-based applications
- trusting role or permission flags from client-side state

---

## DevOps and config review rules

Inspect:
- Dockerfiles
- docker-compose
- Kubernetes manifests
- Helm charts
- Terraform
- GitHub Actions / CI files
- `.env` and template env files
- Nginx / reverse proxy config

Look for:
- secrets in plain text
- root containers
- privileged mode
- exposed admin ports
- insecure defaults
- debug flags
- disabled TLS verification
- overly broad network exposure

---

## False positive handling

Avoid overstating these cases:
- prepared statements that appear dynamic but are safely parameterized
- templating engines that auto-escape by default
- obviously fake placeholder secrets
- internal-only code paths with strong compensating controls
- sanitized markdown pipelines
- allowlisted sort fields implemented correctly

If uncertain, say:
- “likely vulnerable”
- “suspicious pattern”
- “needs manual validation”

---

## Remediation principles

Prefer fixes that:
- eliminate dangerous APIs
- separate data from commands and queries
- use parameter binding
- use allowlists instead of regex-only filters
- validate object ownership on the server
- normalize and validate paths against a safe base directory
- externalize secrets
- reduce privileges
- fail closed
- keep security enforcement on the backend

---

## Review boundaries

This skill is strictly for defensive review.
Do not provide:
- exploit payloads
- bypass instructions
- weaponization steps
- offensive operational guidance

Attack descriptions must remain high level and remediation-focused.

---

## Final checklist

Before finishing, verify that you checked:
- injection risks
- dynamic execution
- XSS
- deserialization
- file/path handling
- auth/authz
- secrets
- Spring Security config
- Actuator exposure
- logging and error leakage
- crypto usage
- SSRF / redirects
- frontend sinks
- Docker / CI / infra misconfiguration
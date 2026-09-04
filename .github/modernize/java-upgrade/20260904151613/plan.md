# Upgrade Plan: facturacion-svc (20260904151613)

- **Generated**: 2026-09-04 15:16
- **HEAD Branch**: N/A (repository has no committed HEAD)
- **HEAD Commit ID**: N/A (repository has no committed HEAD)

## Available Tools

**JDKs**
- JDK 21.0.8: C:\Program Files\Java\jdk-21\bin (current project JDK; baseline)
- JDK 25: **<TO_BE_INSTALLED>** (required for upgrade and final validation)

**Build Tools**
- Maven: **<TO_BE_INSTALLED>** (required; no Maven installation detected)

## Guidelines

- Upgrade only the Java runtime/compiler target to the latest LTS version requested.
- Preserve application behavior and existing dependency versions unless Java 25 compatibility requires a change.
- Keep existing untracked project files; do not discard user work.

> Note: You can add any specific guidelines or constraints for the upgrade process here if needed, bullet points are preferred.

## Options

- Working branch: appmod/java-upgrade-20260904151613
- Run tests before and after the upgrade: true

## Upgrade Goals

- Java runtime/compiler target: 25

## Technology Stack

| Technology/Dependency | Current | Min Compatible Version | Why Incompatible |
| --------------------- | ------- | ----------------------- | ---------------- |
| Java | 21 | 25 | User requested latest LTS runtime |
| Spring Boot | 3.3.5 | 3.3.5 | No framework upgrade required for Java target |
| Maven | Not installed | 3.9+ | Required to build and test; Maven 3.9 is recommended for Java 25 |
| maven-compiler-plugin | Spring Boot parent managed | Compatible with Java 25 via javac release 25 | Verify parent-managed plugin during build |
| maven-surefire-plugin | 3.2.5 | 3.0+ | Already compatible with modern JDKs |
| JaCoCo Maven plugin | 0.8.12 | 0.8.12 | Already supports current JDK line; retain unless validation shows otherwise |
| Cucumber | 7.18.1 | 7.18.1 | Test dependency; no Java-target change needed |

## Derived Upgrades

- Java 25 requires a JDK 25 installation for compilation and runtime validation.
- Maven 3.9+ is required/recommended for a reliable Java 25 build; install it because no system Maven was detected.
- Docker build and runtime images must move from Java 21 to Java 25 so the deployed runtime matches the project target.
- No Kotlin, Jakarta namespace migration, or Spring Boot major upgrade was detected; no related changes are derived.

## Impact Analysis

### Dependency Changes

| File | Dependency | Current | Action | Target | Reason |
|------|------------|---------|--------|--------|--------|
| pom.xml | `java.version` property | 21 | upgrade | 25 | Sets Maven compiler and Spring Boot Java target |
| pom.xml | Spring Boot parent | 3.3.5 | retain | 3.3.5 | Java-only upgrade; no evidence requires framework change |
| pom.xml | Maven plugins/dependencies | Existing managed/direct versions | retain | Existing versions | No Java 25 incompatibility identified before verification |

### Source Code Changes

| File | Location | Current | Required Change | Reason |
|------|----------|---------|----------------|--------|
| src/main/resources/static/index.html | Stack description | Java 21 | Replace with Java 25 | Keep user-facing project metadata accurate |

### Configuration Changes

No application runtime configuration changes are required. `application.yml` contains no Java-version-specific settings.

### CI/CD Changes

| File | Location | Current | Required Change |
|------|----------|---------|----------------|
| Dockerfile | build image | `maven:3.9-eclipse-temurin-21` | Change to Java 25 Maven image | Build with the target JDK |
| Dockerfile | runtime image | `eclipse-temurin:21-jre` | Change to `eclipse-temurin:25-jre` | Run with the target LTS JRE |

### Documentation Changes

| File | Location | Current | Required Change | Reason |
|------|----------|---------|----------------|--------|
| README.md | Stack table | Java 21 | Replace with Java 25 | Document supported runtime |
| docs/00_Resumen.md | Technology table | Java 21 | Replace with Java 25 | Keep summary accurate |
| docs/04_Despliegue.md | Local prerequisites | Java 21 | Replace with Java 25 | Match build instructions |
| docs/05_Justificacion.md | Technology table | Java 21 + Spring Boot 3.3 | Replace Java 21 with Java 25 | Match selected runtime |
| docs/diagramas/c4/C4-2-Contenedores.puml | Container technology label | Java 21 | Replace with Java 25 | Keep architecture diagram source accurate |
| docs/diagramas/c4/C4-3-Componentes.puml | Component technology labels | Java 21 | Replace with Java 25 | Keep architecture diagram source accurate |

### Risks & Warnings

- **Java 25 toolchain availability**: JDK 25 and Maven are absent locally. **Mitigation**: Install JDK 25 and Maven 3.9+, then run baseline and target compilation/tests.
- **Spring Boot 3.3.5 on Java 25**: This is a runtime compatibility risk because the framework line predates Java 25. **Mitigation**: Preserve the framework version unless build/tests fail; validate the complete test suite and packaged application build.
- **Docker image tag availability**: The Java 25 Maven/JRE tags must resolve from the configured registry. **Mitigation**: Validate Docker image references during deployment review; Maven build remains the primary local verification.
- **Repository has no committed HEAD and many untracked files**: Version-control history cannot provide a baseline commit. **Mitigation**: Preserve all files and use the requested upgrade branch tooling without discarding work.

## Upgrade Steps

- Step 1: Setup Environment
  - **Rationale**: Install the missing target JDK and Maven before any build or source changes.
  - **Changes to Make**: Install JDK 25 and Maven 3.9+.
  - **Verification**: List installed JDKs and Maven; expected JDK 25 and Maven available.

- Step 2: Setup Baseline
  - **Rationale**: Establish pre-upgrade compilation and test results using the available JDK 21.
  - **Changes to Make**: None to project files; execute baseline commands.
  - **Verification**: `mvn clean compile test-compile -q && mvn clean test -q`, JDK 21; expected baseline recorded.

- Step 3: Upgrade Java Target and Runtime Metadata
  - **Rationale**: Apply the Java 25 target consistently across Maven, Docker, documentation, and the static landing page.
  - **Changes to Make**: Apply all Dependency Changes, Source Code Changes, CI/CD Changes, and Documentation Changes above.
  - **Verification**: `mvn clean test-compile -q` with JDK 25; expected main and test compilation success.

- Step 4: CVE Validation and Fix
  - **Rationale**: Confirm direct dependencies remain secure after the build metadata change.
  - **Changes to Make**: Scan direct dependencies; upgrade only vulnerable dependencies with patched compatible versions.
  - **Verification**: Compile, re-scan dependencies, and confirm all reported CVEs are resolved or documented as having no available patch.

- Step 5: Final Validation
  - **Rationale**: Confirm all target versions, tests, packaging, and coverage requirements are met.
  - **Changes to Make**: Resolve any Java 25 compilation/test/runtime issues and remove temporary workarounds.
  - **Verification**: `mvn clean test-compile -q`, `mvn clean test -q`, and `mvn clean verify -Djacoco.skip=false`; expected 100% tests passing and existing coverage gate passing.

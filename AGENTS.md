# AGENTS.md

Guidance for AI coding agents working in this repository (**podku** — a podcast app).
Read this first. It covers the architecture, environment rules, and conventions that
most commonly trip people up.

## Table of Contents
- [Project Overview](#project-overview)
- [Golden Rules (read before doing anything)](#golden-rulesread-before-doing-anything)
- [Repository Layout](#repository-layout)
- [Environment & Toolchain](#environment--toolchain)
- [Building, Running & Testing](#building-running--testing)
- [Backend (Java / Spring Boot)](#backendjava--spring-boot)
- [Frontend App (Flutter / Dart)](#frontend-appflutter--dart)
- [podkunnect (Dart CLI node)](#podkunnectdart-cli-node)
- [Shared Code & Generated Client](#shared-code--generated-client)
- [Configuration & Environment Variables](#configuration--environment-variables)
- [Conventions](#conventions)
- [Common Tasks](#common-tasks)

## Project Overview

Podku is a self-hosted podcast application with three parts:

1. **Backend** — Java 25 + Spring Boot, exposes a REST + WebSocket API, stores data in PostgreSQL, serves the web app as static content.
2. **App** — Flutter/Dart client (web, Android, iOS, macOS, Windows) using BLoC state management.
3. **podkunnect** — a Dart CLI "node" that connects to a server for remote/playback-audio scenarios (uses `media_kit`/mpv).

The backend is the source of truth for the API contract: the Dart client is generated from its OpenAPI spec.

## Golden Rules (read before doing anything)

- **Always run Java/Maven inside the nix shell.** The system JDK is older than the project's Java 25 target, so `mvn`/`java` on PATH will fail. Use:
  ```bash
  nix-shell --run 'mvn compile'
  nix-shell --run 'mvn test'
  nix-shell --run 'mvn package'
  ```
- **Always run Flutter/Dart commands inside the nix shell** (it puts `submodules/flutter/bin` on PATH and sets up the submodule). From the repo root:
  ```bash
  nix-shell --run "flutter ..."   # or cd src/main/app && nix-shell --run 'dart ...'
  ```
- **Do not commit generated code.** `podku_client/`, `/target/`, `/image-cache/`, `/episode-cache/`, and the built Flutter output in `src/main/resources/public/` are gitignored / generated. Regenerate them (see [Common Tasks](#common-tasks)).
- **Prefer path dependencies over published packages** for `podku_shared` and `podku_client` (see pubspec files). Don't publish these internally.
- When changing the API, regenerate the Dart client so app/podkunnect stay in sync.

## Repository Layout

```
pom.xml                     Maven build (Spring Boot parent, Java 25)
shell.nix                   Dev shell: jdk25_headless, maven, flutter, openapi-generator-cli
flake.nix                   Builds the podkunnect CLI package + systemd module
Makefile                    Helper targets (build_runner, client gen, android-auto emulator)
docker/Dockerfile           Runtime image (ibm-semeru open-25-jre), serves jar + static web assets
docker-compose.yaml         Local PostgreSQL (pgvector/pg18) on port 8090
src/main/java/...           Backend (com.github.lamarios.podku.*)
src/main/app/              Flutter app (lib/, pubspec.yaml)
src/main/podkunnect/       Dart CLI node (bin/, lib/, Makefile, flake build)
podku_shared/              Shared Dart models (freezed/json_serializable), path dep
podku_client/              Generated OpenAPI client (dart-dio), path dep
src/main/resources/        application.yml + Flyway migrations + served web assets
docs/                      Project documentation (index.html, privacy.html)
.github/workflows/         CI: build-backend, build-android, build-podkunnect
submodules/flutter         Flutter SDK (git submodule)
```

## Environment & Toolchain

- **Nix** is the single source of truth for tooling. `shell.nix` provides `jdk25_headless`, `maven`, `flutter`, `fastlane`, and a pinned `openapi-generator-cli`. It also inits git submodules and installs Dart pre-commit hooks on shell entry.
- **Java 25** (via `jdk25_headless`), **Spring Boot 4.0.6**.
- **Flutter ^3.32 / Dart ^3.10** for the app; **Dart ^3.12** for podkunnect and podku_shared.
- **PostgreSQL** (pgvector) via Flyway migrations in `src/main/resources/db/migration/` (`V2__` … `V8__`).
- Codegen: `freezed` + `json_serializable` + `build_runner`; OpenAPI client via `openapi-generator-cli` (`dart-dio`).

## Building, Running & Testing

Backend (inside nix shell):
```bash
nix-shell --run 'mvn clean install'      # compile + package (spring-boot repackage)
nix-shell --run 'mvn test'               # tests use Testcontainers (Postgres)
```

App (inside nix shell):
```bash
cd src/main/app && nix-shell --run 'flutter pub get'
nix-shell --run "flutter build web --release ..."   # output -> src/main/resources/public
```

podkunnect:
```bash
make -C src/main/podkunnect compile-linux-x64    # or: nix build .#default
```

Local database (separate terminal):
```bash
docker compose up -d        # postgres on localhost:8090, db "podku"
```

## Backend (Java / Spring Boot)

- Entry point: `src/main/java/com/github/lamarios/podku/Application.java` (`@SpringBootApplication`, `@EnableScheduling`, springdoc OpenAPI at `/v3/api-docs.yaml`, Swagger UI).
- Server runs on **port 8080**; health endpoint `/actuator/health`.
- Packages under `com.github.lamarios.podku`:
  - `podcasts/` — podcast fetching (OPML/Feeds), parsing, controllers/services/repos.
  - `episodes/` — episode models, chapters, SRT/VTT transcript parsers, search results.
  - `bookmarks/` — episode bookmarks (+ bookmark-with-transcript).
  - `search/` — Itunes podcast search + unified search controller.
  - `transcripts/` — Whisper transcription service + transcript storage.
  - `websockets/` — remote playback commands over WebSocket (player status, remote commands).
  - `urls/`, `staticContent/`, `models/`, `utils/`, `Config.java`.
- Persistence: Spring Data JPA + PostgreSQL; schema via **Flyway** migrations (`classpath:db/migration`). Add a new migration with an incremented version prefix (e.g. `V9__...sql`) when the schema changes.
- HTTP client: Unirest; caching helpers in `utils/` (e.g. `TransactionHelper`, `FastUrlCrypto`).

## Frontend App (Flutter / Dart)

- Architecture: **feature-based folders** (`lib/<feature>/{models,states,views}`), **BLoC** (`flutter_bloc`) for state, **`get_it`** for DI, **`go_router`** for routing.
- Codegen is required: models use `freezed` + `json_serializable`. After editing a model, run the build runner (see Makefile / [Common Tasks](#common-tasks)).
- Playback/offline: `just_audio`, `audio_service`, `background_downloader`.
- The built web app (`flutter build web`) is copied to `src/main/resources/public/` and served by the backend. Web target builds to **WASM**.
- Localizations live in `lib/l10n/`.

## podkunnect (Dart CLI node)

- A command-line node that connects to a Podku server for remote playback; uses `media_kit` + mpv for audio.
- Built with `dart compile exe` (see its `Makefile`) or via the nix flake (`nix build .#default`). The flake also defines a user systemd service module (`services.podkunnect`).
- Depends on `podku_shared` and `podku_client` via path.

## Shared Code & Generated Client

- **`podku_shared/`** — shared Dart models (freezed/json_serializable) used by both the app and podkunnect. Path dependency; regenerate with build runner after edits.
- **`podku_client/`** — generated OpenAPI client (`dart-dio`, `json_serializable`). Generated from the backend's live spec. Regenerate it whenever the API changes (see [Common Tasks](#common-tasks)).

## Configuration & Environment Variables

Read `src/main/resources/application.yml`. Key env vars:

- DB: `DB_HOST`, `DB_PORT` (default 8090), `DB_DATABASE` (default `podku`), `DB_USER`, `DB_PASSWORD`.
- Episode cache: `EPISODE_CACHE_DIR` (default `./episode-cache`), `EPISODE_CACHE_COUNT`.
- Whisper transcription: `WHISPER_URL`, `WHISPER_MODEL` (default `base`), `WHISPER_API_KEY`, `WHISPER_EPISODE_PROCESS_COUNT`.

## Conventions

- **Java formatting** is enforced by Spotless (`googleJavaFormat`, `cleanthat`, `removeUnusedImports`) via the Maven build — keep code formatted or `mvn` will fail the check.
- **Dart**: run `dart analyze` (and `flutter analyze`) before finishing; respect `analysis_options.yaml` in each Dart package.
- Keep generated files out of git/version control; regenerate instead of hand-editing them.
- Match surrounding code style (indentation, naming, KDoc/Javadoc, file layout) rather than imposing a new one.

## Common Tasks

Regenerate the Flutter app's serialized/freezed code:
```bash
make build-runner            # cd src/main/app && dart run build_runner build --delete-conflicting-outputs
```

Regenerate the Dart OpenAPI client from a running backend (backend must be up on :8080):
```bash
make generate-client         # openapi-generator-cli -> podku_client, then codegen + flutter clean + pub get
```

Build podkunnect:
```bash
make -C src/main/podkunnect compile-linux-x64
```

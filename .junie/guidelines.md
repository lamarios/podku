# Junie guidelines

Document the changes you make in the AI_DISCLOSURE.md file so that my code as a proper log of what is made using AI or not. Keep it simple and straight forward in this, do not describe every file change, more like the task as a whole.

## Building Java / running Maven

- The system's default JDK is older than the project's Java 25 target, so `mvn` must run inside the project's nix shell.
- Run all Java/Maven commands from the repository root via the nix shell, e.g. `nix-shell --run 'mvn compile'`, `nix-shell --run 'mvn test'`, `nix-shell --run 'mvn package'`.
- Do not rely on the ambient `java`/`mvn` on PATH for this project; the nix shell provides `jdk25_headless` and `maven` (see `shell.nix`).

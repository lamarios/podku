# Build from the project root with:
# docker build -f podku_server/Dockerfile .

# Build stage
FROM dart:3.11.0 AS build
WORKDIR /app
COPY pubspec.lock .
COPY podku_server podku_server
COPY podku_shared podku_shared
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.8.0' \
  'workspace:' \
  '  - podku_server' \
  > pubspec.yaml
RUN dart pub get
WORKDIR /app/podku_server
RUN dart compile exe bin/main.dart -o bin/server
RUN mkdir -p config web migrations

# Caddy stage
FROM caddy:2-alpine AS caddy

# Final stage
FROM alpine:latest
WORKDIR /app

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

RUN apk add --no-cache ca-certificates

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=build /app/podku_server/docker/CaddyFile /etc/caddy/Caddyfile

COPY --from=build /runtime/ /
COPY --from=build /app/podku_server/bin/server server
COPY --from=build /app/podku_server/config/ config/
COPY --from=build /app/podku_server/web/ web/
COPY --from=build /app/podku_server/migrations/ migrations/
COPY --from=build /app/podku_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

COPY --from=build /app/podku_server/docker/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8080
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084

ENTRYPOINT ["./entrypoint.sh"]
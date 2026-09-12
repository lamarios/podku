# Installation

## Docker

Here's a sample docker compose file to install Newsku

```yaml
services:
  podku-db:
    image: pgvector/pgvector:pg18
    container_name: podku-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_DB: podku
      POSTGRES_PASSWORD: "podku"
    volumes:
      - ./podku/db:/var/lib/postgresql
  podku:
    container_name: podku
    image: gonzague/podku:latest
    restart: unless-stopped
    volumes:
      - ./podku/app/image-cache:/image-cache
      - ./podku/app/episode-cache:/episode-cache
    environment:
      DB_HOST: podku-db
      DB_PORT: 5432
      DB_DATABASE: podku
      DB_USER: postgres
      DB_PASSWORD: podku
      # openssl rand -base64 32
      SALT: xxxxxxxx
      ##
      # All the configuration below is optional
      ##
      # Last x episodes to download for local cache
      EPISODE_CACHE_COUNT: 20
      # whisper server to do episode transcript
      WHISPER_URL: http://whisper:9000
      WHISPER_API_KEY: abc
      WHISPER_MODEL: base
      WHISPER_EPISODE_PROCESS_COUNT: 20
      # OpenAI compatible api for AI related features ( finding the topic of an episode bookmark for example)
      OPENAI_API_KEY: no-key
      OPENAI_MODEL: openai-gpt-oss:20B
      OPENAI_URL: https://llama-cpp/v1
  # The whisper server is optional
  whisper:
    image: hwdsl2/whisper-server
    container_name: whisper
    restart: always
    environment:
      WHISPER_MODEL: small
      WHISPER_API_KEY: abc
      WHISPER_THREADS: 12
      WHISPER_MAX_UPLOAD_MB: 0
    volumes:
      - ./podku-whisper:/var/lib/whisper
```

Open a browser to http://localhost:8080 and the application should appear. You can also download the android application from the release page on [github](https://github.com/lamarios/podku/releases) to access your server.
To use **Android Auto** you **must** use the application from the [Google Play store](https://play.google.com/store/apps/details?id=com.github.lamarios.podku)
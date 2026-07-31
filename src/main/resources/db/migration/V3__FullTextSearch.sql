ALTER TABLE podcasts ADD COLUMN "search_vector" tsvector
    GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,''))
        ) STORED;

CREATE INDEX idx_podcast_search ON podcasts USING GIN ("search_vector");

ALTER TABLE episodes ADD COLUMN "search_vector" tsvector
    GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,''))
        ) STORED;

CREATE INDEX idx_episode_search ON episodes USING GIN ("search_vector");

ALTER TABLE episode_transcripts ADD COLUMN "search_vector" tsvector
    GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(content,''))
        ) STORED;

CREATE INDEX idx_content_search ON episode_transcripts USING GIN ("search_vector");

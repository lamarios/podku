ALTER TABLE episode_bookmarks
    ADD COLUMN topic         text,
    ADD COLUMN search_vector tsvector GENERATED ALWAYS AS (
        TO_TSVECTOR('english', topic)
        ) STORED;

CREATE INDEX idx_bookmark_topic_search ON episode_bookmarks USING GIN ("search_vector");

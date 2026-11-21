-- cache of the podcasts recommended for an episode, see RecommendationService
CREATE TABLE episode_recommendations
(
    "episode_id"  uuid PRIMARY KEY REFERENCES episodes (id) ON DELETE CASCADE,
    "computed_at" timestamptz NOT NULL,
    -- JSON array of iTunes search results, best match first
    "results"     text        NOT NULL
);

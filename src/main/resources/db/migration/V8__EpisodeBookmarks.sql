CREATE TABLE episode_bookmarks
(
    "id"         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "time"       bigint,
    "episode_id" uuid NOT NULL
);

ALTER TABLE ONLY "episode_bookmarks"
    ADD CONSTRAINT "episode_bookmarks_fk_0"
        FOREIGN KEY ("episode_id")
            REFERENCES "episodes" ("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

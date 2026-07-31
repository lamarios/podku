--
-- Class Chapter as table episode_chapters
--
CREATE TABLE "episode_chapters" (
                                    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                                    "start_time" double precision NOT NULL,
                                    "title" text,
                                    "img" text,
                                    "toc" boolean NOT NULL DEFAULT true,
                                    "end_time" double precision,
                                    "episode_id" uuid
);

--
-- Class EpisodeFile as table episode_files
--
CREATE TABLE "episode_files" (
                                 "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                                 "type" text NOT NULL,
                                 "mime" text,
                                 "url" text NOT NULL,
                                 "language" text,
                                 "rel" text,
                                 "episode_id" uuid NOT NULL
);

--
-- Class EpisodePerson as table episode_people
--
CREATE TABLE "episode_people" (
                                  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                                  "name" text NOT NULL,
                                  "role" text,
                                  "group" text,
                                  "image" text,
                                  "link" text,
                                  "episode_id" uuid NOT NULL
);

--
-- Class EpisodeTranscript as table episode_transcripts
--
CREATE TABLE "episode_transcripts" (
                                       "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                                       "start_time" text NOT NULL,
                                       "end_time" text NOT NULL,
                                       "speaker" text,
                                       "content" text NOT NULL,
                                       "language" text,
                                       "episode_id" uuid NOT NULL
);

-- Indexes
CREATE INDEX "episode_language_idx" ON "episode_transcripts" USING btree ("language", "episode_id");

--
-- Class Episode as table episodes
--
CREATE TABLE "episodes" (
                            "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                            "title" text NOT NULL,
                            "description" text,
                            "audio_url" text,
                            "audio_type" text,
                            "audio_length_bytes" bigint,
                            "pub_date_millis" bigint,
                            "duration_seconds" bigint,
                            "guid" text,
                            "image_url" text,
                            "season_number" bigint,
                            "episode_number" bigint,
                            "episode_type" text,
                            "explicit" boolean NOT NULL,
                            "link" text,
                            "podcast_id" uuid NOT NULL,
                            "progress" double precision NOT NULL DEFAULT 0.000,
                            "processed" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "timeIndex" ON "episodes" USING btree ("pub_date_millis");

--
-- Class PodcastPerson as table podcast_people
--
CREATE TABLE "podcast_people" (
                                  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                                  "name" text NOT NULL,
                                  "role" text,
                                  "group" text,
                                  "image" text,
                                  "link" text,
                                  "podcast_id" uuid NOT NULL
);

--
-- Class Podcast as table podcasts
--
CREATE TABLE "podcasts" (
                            "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                            "url" text NOT NULL,
                            "name" text NOT NULL,
                            "artwork_url" text,
                            "description" text,
                            "author" text,
                            "link" text
);
--
-- Foreign relations for "episode_chapters" table
--
ALTER TABLE ONLY "episode_chapters"
    ADD CONSTRAINT "episode_chapters_fk_0"
        FOREIGN KEY("episode_id")
            REFERENCES "episodes"("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

--
-- Foreign relations for "episode_files" table
--
ALTER TABLE ONLY "episode_files"
    ADD CONSTRAINT "episode_files_fk_0"
        FOREIGN KEY("episode_id")
            REFERENCES "episodes"("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

--
-- Foreign relations for "episode_people" table
--
ALTER TABLE ONLY "episode_people"
    ADD CONSTRAINT "episode_people_fk_0"
        FOREIGN KEY("episode_id")
            REFERENCES "episodes"("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

--
-- Foreign relations for "episode_transcripts" table
--
ALTER TABLE ONLY "episode_transcripts"
    ADD CONSTRAINT "episode_transcripts_fk_0"
        FOREIGN KEY("episode_id")
            REFERENCES "episodes"("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

--
-- Foreign relations for "episodes" table
--
ALTER TABLE ONLY "episodes"
    ADD CONSTRAINT "episodes_fk_0"
        FOREIGN KEY("podcast_id")
            REFERENCES "podcasts"("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

--
-- Foreign relations for "podcast_people" table
--
ALTER TABLE ONLY "podcast_people"
    ADD CONSTRAINT "podcast_people_fk_0"
        FOREIGN KEY("podcast_id")
            REFERENCES "podcasts"("id")
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

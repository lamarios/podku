BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "episodes" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "title" text NOT NULL,
    "description" text,
    "audioUrl" text,
    "audioType" text,
    "audioLengthBytes" bigint,
    "pubDateMillis" bigint,
    "durationSeconds" bigint,
    "guid" text,
    "imageUrl" text,
    "seasonNumber" bigint,
    "episodeNumber" bigint,
    "episodeType" text,
    "explicit" boolean NOT NULL,
    "link" text,
    "podcastId" uuid NOT NULL,
    "progress" double precision NOT NULL DEFAULT 0,
    "_podcastsEpisodesPodcastsId" uuid
);

-- Indexes
CREATE INDEX "timeIndex" ON "episodes" USING btree ("pubDateMillis");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "podcasts" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "url" text NOT NULL,
    "name" text NOT NULL,
    "artworkUrl" text,
    "description" text,
    "author" text,
    "link" text
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "episodes"
    ADD CONSTRAINT "episodes_fk_0"
    FOREIGN KEY("podcastId")
    REFERENCES "podcasts"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "episodes"
    ADD CONSTRAINT "episodes_fk_1"
    FOREIGN KEY("_podcastsEpisodesPodcastsId")
    REFERENCES "podcasts"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR podku
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('podku', '20260709101207817', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260709101207817', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;

-- podcast 2.0 alternate enclosures: episodes can have multiple audio/video media, stored in
-- episode_files with the "audio" and "video" types
ALTER TABLE episode_files
    ADD COLUMN "length_bytes" bigint,
    ADD COLUMN "bitrate" double precision,
    ADD COLUMN "height" integer,
    ADD COLUMN "title" text,
    ADD COLUMN "codecs" text,
    ADD COLUMN "default_media" boolean;

-- copy the existing enclosures, mirroring what the parser stores for an item's <enclosure>
INSERT INTO episode_files ("type", "mime", "url", "length_bytes", "default_media", "episode_id")
SELECT CASE WHEN lower(audio_type) LIKE 'video/%' THEN 'video' ELSE 'audio' END,
       audio_type,
       audio_url,
       audio_length_bytes,
       true,
       id
FROM episodes
WHERE audio_url IS NOT NULL
  AND audio_url <> '';

CREATE INDEX "episodeFilesEpisodeIdIndex" ON episode_files ("episode_id");

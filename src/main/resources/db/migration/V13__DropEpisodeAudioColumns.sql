-- episode media now only live in episode_files (copied there by V12)
ALTER TABLE episodes
    DROP COLUMN "audio_url",
    DROP COLUMN "audio_type",
    DROP COLUMN "audio_length_bytes";

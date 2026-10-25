-- HTTP validators of the last fetched feed, sent back on refresh to get a 304 when nothing changed
ALTER TABLE podcasts
    ADD COLUMN "etag"          text,
    ADD COLUMN "last_modified" text;

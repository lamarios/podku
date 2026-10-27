-- time of the last playback progress change, time_updated can't be used for this as it also changes
-- on feed refresh and episode processing
ALTER TABLE episodes
    ADD COLUMN "progress_updated" bigint;

CREATE INDEX "progressUpdatedIndex" ON episodes ("progress_updated" DESC) WHERE "progress" > 0;

-- Resets the demo instance: keeps only the demo podcasts and clears visitor activity.
BEGIN;

-- Episodes, chapters, transcripts, files, people and bookmarks cascade
DELETE FROM podcasts WHERE url NOT IN (
  'https://feeds.megaphone.fm/IDG8935300959',                 -- The Full Nerd Podcast
  'https://feeds.megaphone.fm/COME6354333076',                -- The Co-Main Event MMA Podcast
  'https://feeds.fireside.fm/destinationlinux/rss',           -- Destination Linux
  'https://feeds.megaphone.fm/LMG3928170156',                 -- The WAN Show
  'https://feeds.jupiterbroadcasting.com/lup',                -- LINUX Unplugged
  'https://feeds.captivate.fm/taskmaster-the-peoples-podcast/', -- Taskmaster: The People's Podcast
  'https://feeds.captivate.fm/taskmaster-the-podcast/'        -- Taskmaster The Podcast
);

-- Clear what visitors did to the podcasts we keep
DELETE FROM episode_bookmarks;
UPDATE episodes SET progress = 0 WHERE progress <> 0;

COMMIT;

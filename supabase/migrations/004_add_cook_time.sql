-- Migration: add a modern `cook_time` column to recipes (minutes)
-- This creates `cook_time` in case some DBs use that naming instead of `cook_time_minutes`.

ALTER TABLE IF EXISTS recipes
  ADD COLUMN IF NOT EXISTS cook_time integer;

-- Optional: populate `cook_time` from `cook_time_minutes` when present
UPDATE recipes
SET cook_time = cook_time_minutes
WHERE cook_time IS NULL AND cook_time_minutes IS NOT NULL;

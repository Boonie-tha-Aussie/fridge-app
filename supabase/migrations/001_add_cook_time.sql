-- Migration: add cook_time_minutes to recipes
-- Run this in your Supabase SQL editor or via migration tooling.

-- Add an integer column for cook time (minutes)
ALTER TABLE IF EXISTS recipes
ADD COLUMN IF NOT EXISTS cook_time_minutes integer;

-- Optional: set a default or update existing rows with example values
-- UPDATE recipes SET cook_time_minutes = 30 WHERE title ILIKE '%spaghetti%';
-- UPDATE recipes SET cook_time_minutes = 20 WHERE title ILIKE '%taco%';

-- Verify schema
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'recipes';

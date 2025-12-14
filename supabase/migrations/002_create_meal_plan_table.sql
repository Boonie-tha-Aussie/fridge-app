-- Migration: create meal_plan table to map days to recipes
-- Each row represents a single day's planned meal (or NULL if unplanned)

CREATE TABLE IF NOT EXISTS meal_plan (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  day_of_week TEXT NOT NULL CHECK (day_of_week IN ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')),
  recipe_id UUID REFERENCES recipes(id) ON DELETE SET NULL,
  recipe_title TEXT, -- denormalized for easier display
  cook_time_minutes INTEGER, -- denormalized for easier display
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT unique_day_per_week UNIQUE (day_of_week)
);

-- Optional: Insert one example row for Monday with "Spaghetti with Tomato Sauce" and 25 min
-- INSERT INTO meal_plan (day_of_week, recipe_title, cook_time_minutes)
-- VALUES ('Monday', 'Spaghetti with Tomato Sauce', 25);
-- All other days remain NULL (unplanned).

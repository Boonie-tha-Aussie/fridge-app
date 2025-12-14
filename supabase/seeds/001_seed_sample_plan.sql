-- Seed: insert a sample recipe and a meal plan with a Monday DINNER item
-- Run these statements in the Supabase SQL editor to create a sample plan for testing.

DO $$
DECLARE
  r_id UUID;
  p_id UUID;
BEGIN
  -- Insert sample recipe (adjust fields to your schema)
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'recipes' AND column_name = 'cook_time'
  ) THEN
    INSERT INTO recipes (title, cook_time)
    VALUES ('Spaghetti with Tomato Sauce', 25)
    RETURNING id INTO r_id;
  ELSIF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'recipes' AND column_name = 'cook_time_minutes'
  ) THEN
    INSERT INTO recipes (title, cook_time_minutes)
    VALUES ('Spaghetti with Tomato Sauce', 25)
    RETURNING id INTO r_id;
  ELSE
    INSERT INTO recipes (title)
    VALUES ('Spaghetti with Tomato Sauce')
    RETURNING id INTO r_id;
  END IF;

  -- Create a sample meal plan
  INSERT INTO meal_plans (name)
  VALUES ('Sample Week')
  RETURNING id INTO p_id;

  -- Link the recipe to Monday DINNER
  INSERT INTO meal_plan_items (meal_plan_id, day_of_week, meal_type, recipe_id)
  VALUES (p_id, 'Monday', 'DINNER', r_id);
END$$;

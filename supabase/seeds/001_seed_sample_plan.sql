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

  -- Create a sample meal plan (be tolerant of schema differences)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'meal_plans') THEN
    -- meal_plans table exists; attempt to insert a named plan
    IF EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_name = 'meal_plans' AND column_name = 'name'
    ) THEN
      INSERT INTO meal_plans (name)
      VALUES ('Sample Week')
      RETURNING id INTO p_id;
    ELSIF EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_name = 'meal_plans' AND column_name = 'title'
    ) THEN
      INSERT INTO meal_plans (title)
      VALUES ('Sample Week')
      RETURNING id INTO p_id;
    ELSE
      -- No obvious name/title column; insert defaults and get id
      INSERT INTO meal_plans DEFAULT VALUES RETURNING id INTO p_id;
    END IF;

    -- Link the recipe to Monday DINNER if items table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'meal_plan_items') THEN
      INSERT INTO meal_plan_items (meal_plan_id, day_of_week, meal_type, recipe_id)
      VALUES (p_id, 'Monday', 'DINNER', r_id);
    ELSIF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'meal_plan') THEN
      -- older singular table schema
      IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'meal_plan' AND column_name = 'cook_time'
      ) THEN
        INSERT INTO meal_plan (day_of_week, recipe_id, recipe_title, cook_time)
        VALUES ('Monday', r_id, 'Spaghetti with Tomato Sauce', 25);
      ELSIF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'meal_plan' AND column_name = 'cook_time_minutes'
      ) THEN
        INSERT INTO meal_plan (day_of_week, recipe_id, recipe_title, cook_time_minutes)
        VALUES ('Monday', r_id, 'Spaghetti with Tomato Sauce', 25);
      ELSE
        INSERT INTO meal_plan (day_of_week, recipe_id, recipe_title)
        VALUES ('Monday', r_id, 'Spaghetti with Tomato Sauce');
      END IF;
    END IF;

  ELSE
    -- No plural table; try singular `meal_plan` table
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'meal_plan') THEN
      IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'meal_plan' AND column_name = 'cook_time'
      ) THEN
        INSERT INTO meal_plan (day_of_week, recipe_id, recipe_title, cook_time)
        VALUES ('Monday', r_id, 'Spaghetti with Tomato Sauce', 25);
      ELSIF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'meal_plan' AND column_name = 'cook_time_minutes'
      ) THEN
        INSERT INTO meal_plan (day_of_week, recipe_id, recipe_title, cook_time_minutes)
        VALUES ('Monday', r_id, 'Spaghetti with Tomato Sauce', 25);
      ELSE
        INSERT INTO meal_plan (day_of_week, recipe_id, recipe_title)
        VALUES ('Monday', r_id, 'Spaghetti with Tomato Sauce');
      END IF;
    END IF;
  END IF;
END$$;

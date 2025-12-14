-- Migration: create meal_plans and meal_plan_items tables

-- Higher-level meal_plan (a plan instance)
CREATE TABLE IF NOT EXISTS meal_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Items linking meal_plans to recipes for specific days and meal types
CREATE TABLE IF NOT EXISTS meal_plan_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_plan_id UUID REFERENCES meal_plans(id) ON DELETE CASCADE,
  day_of_week TEXT NOT NULL CHECK (day_of_week IN ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')),
  meal_type TEXT NOT NULL,
  recipe_id UUID REFERENCES recipes(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT unique_plan_day_type UNIQUE (meal_plan_id, day_of_week, meal_type)
);

-- Note: After running this migration, insert a meal_plan and link items. Example:
-- INSERT INTO meal_plans (name) VALUES ('Week of 2025-12-14');
-- INSERT INTO meal_plan_items (meal_plan_id, day_of_week, meal_type, recipe_id)
-- VALUES ('<plan-id>', 'Monday', 'DINNER', '<recipe-uuid>');

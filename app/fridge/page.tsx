// app/fridge/page.tsx

// Fridge display for a tablet-mounted kitchen display.
// - Shows a 7-day dinner plan with large, touch-friendly cards.
// - Simple, modern, high-contrast styling for readability at a distance.

const DAYS_OF_WEEK = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
]

import supabase from '../../lib/supabaseClient'

type MealPlanRow = {
  day_of_week: string
  recipe_title: string | null
  cook_time_minutes: number | null
}

function formattedHeaderDate() {
  const now = new Date()
  return now.toLocaleDateString(undefined, {
    weekday: 'long',
    month: 'long',
    day: 'numeric',
  })
}

export default async function FridgePage() {
  const today = new Date()
  const todayName = DAYS_OF_WEEK[today.getDay()]

  // Fetch the most recent meal plan and its dinner items, joining recipes
  let mealPlanData: Record<string, { title: string | null; cookTime: string }> = {}
  try {
    // get most recent meal plan
    const { data: plans, error: plansErr } = await supabase
      .from('meal_plans')
      .select('id')
      .order('created_at', { ascending: false })
      .limit(1)

    if (plansErr) {
      console.warn('Supabase error fetching meal_plans:', plansErr)
    } else if (Array.isArray(plans) && plans.length > 0 && plans[0].id) {
      const planId = plans[0].id
      // fetch dinner items and join recipes
      const { data: items, error: itemsErr } = await supabase
        .from('meal_plan_items')
        .select('day_of_week, meal_type, recipes(id, title, cook_time_minutes)')
        .eq('meal_plan_id', planId)
        .eq('meal_type', 'DINNER')

      if (itemsErr) {
        console.warn('Supabase error fetching meal_plan_items:', itemsErr)
      } else if (Array.isArray(items)) {
        for (const item of items as any[]) {
          const day = item.day_of_week
          const recipe = item.recipes
          const title = recipe?.title ?? null
          const cookTime = recipe?.cook_time_minutes ? `${recipe.cook_time_minutes} min` : '—'
          mealPlanData[day] = { title, cookTime }
        }
      }
    }
  } catch (err) {
    console.warn('Supabase fetch failed:', err)
  }

  // Build plan for all 7 days; unplanned days will have null title
  const mealPlan = DAYS_OF_WEEK.map((day) => ({
    day,
    title: mealPlanData[day]?.title ?? null,
    cookTime: mealPlanData[day]?.cookTime ?? '—',
  }))

  return (
    <main className="min-h-screen fridge-bg flex flex-col items-center py-6 px-4">
      <header className="w-full max-w-6xl mb-6 flex flex-col items-center">
        <div className="w-full flex items-center justify-between">
          <div>
            <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight">Weekly Dinner</h1>
            <p className="text-lg mt-1 fridge-header-date">{formattedHeaderDate()}</p>
          </div>

          <div className="text-right">
            <span className="inline-block px-4 py-2 rounded-2xl text-sm md:text-base font-medium" style={{background: 'rgba(178,125,87,0.12)', color: 'var(--muted-very-light)'}}>
              Tablet Mode
            </span>
          </div>
        </div>

        <p className="mt-3 text-sm md:text-base fridge-muted">Tap a day to open Cooking Mode (future).</p>
      </header>

      <section className="w-full max-w-6xl grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-7 gap-4">
        {mealPlan.map(({ day, title: meal, cookTime }) => {
          const isToday = day === todayName
          const isPlanned = meal !== null

          return (
            <article
              key={day}
              aria-label={`${day} - ${meal || 'Unplanned'}`}
              className={`w-full relative select-none rounded-3xl p-6 flex flex-col justify-between transition-transform active:scale-[0.985] focus:outline-none focus-visible:ring-4 ${
                    isToday
                      ? 'fridge-card-today'
                      : 'fridge-card'
                  }`}
            >
              <div className="flex items-start justify-between">
                <div>
                  <h2 className="text-2xl md:text-2xl font-bold tracking-tight">{day}</h2>
                  <p className="mt-1 text-sm md:text-sm fridge-muted">{isToday ? 'Today' : ''}</p>
                </div>
                <div className="ml-3">
                  <span
                    className={`inline-block text-xs font-semibold uppercase tracking-wide px-3 py-1 rounded-full ${
                      isPlanned ? 'fridge-tag' : 'bg-yellow-700/30 text-yellow-200'
                    }`}
                  >
                    {isPlanned ? 'Dinner' : 'Unplanned'}
                  </span>
                </div>
              </div>

              {isPlanned ? (
                <p className="mt-6 text-2xl md:text-3xl font-semibold leading-tight" style={{color: 'var(--muted-very-light)'}}>{meal}</p>
              ) : (
                <p className="mt-6 text-2xl md:text-3xl font-semibold leading-tight fridge-muted">No meal planned</p>
              )}

              <div className="mt-4 flex items-center justify-between text-sm">
                <span className={isToday ? 'text-white' : 'fridge-charcoal'}>Prep: —</span>
                <span className={isToday ? 'text-white' : 'fridge-charcoal'}>{cookTime}</span>
              </div>
            </article>
          )
        })}
      </section>
    </main>
  )
}

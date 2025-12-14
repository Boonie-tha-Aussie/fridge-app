import { Pool } from 'pg'

// This test requires a Postgres connection string in the env var `PG_CONN`.
// In CI set the secret `SUPABASE_PG_CONN` and map it to PG_CONN.
const conn = process.env.PG_CONN

if (!conn) {
  test('skipped: PG_CONN not provided', () => {
    console.warn('Skipping DB tests; set PG_CONN to run them')
  })
} else {
  test('seed contains Monday DINNER: Spaghetti with Tomato Sauce', async () => {
    const pool = new Pool({ connectionString: conn, ssl: process.env.PG_ALLOW_SELF_SIGNED ? { rejectUnauthorized: false } : undefined })
    try {
      const res = await pool.query(
        `SELECT r.title FROM meal_plan_items mpi
         LEFT JOIN recipes r ON mpi.recipe_id = r.id
         WHERE mpi.meal_type = 'DINNER' AND mpi.day_of_week::text IN ('Monday','1') LIMIT 1`
      )
      await pool.end()
      expect(res.rowCount).toBeGreaterThan(0)
      const title = res.rows[0].title
      expect(title).toBeTruthy()
      expect(title).toMatch(/Spaghetti/i)
    } finally {
      await pool.end().catch(() => {})
    }
  })
}

import { createClient, SupabaseClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY in environment')
}

declare global {
  // allow global `__supabase` for HMR-safe singleton in dev
  // eslint-disable-next-line @typescript-eslint/no-namespace
  var __supabase: SupabaseClient | undefined
}

const getSupabase = (): SupabaseClient => {
  if (process.env.NODE_ENV === 'production') {
    return createClient(supabaseUrl, supabaseAnonKey)
  }

  if (!globalThis.__supabase) {
    globalThis.__supabase = createClient(supabaseUrl, supabaseAnonKey)
  }

  return globalThis.__supabase
}

const supabase = getSupabase()

export default supabase

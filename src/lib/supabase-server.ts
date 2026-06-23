import { createServerClient } from '@supabase/ssr'

export function createSupabaseServerClient(request: Request) {
  const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL
  const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY

  const cookies = request.headers.get('cookie') ?? ''

  return createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      get(name: string) {
        const match = cookies.match(new RegExp(`(?:^|;\\s*)${name}=([^;]*)`))
        return match?.[1] ?? null
      },
      set() {},
      remove() {},
    },
  })
}

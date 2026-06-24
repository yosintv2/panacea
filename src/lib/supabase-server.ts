import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY

export function createSupabaseServerClient() {
  const client = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false,
    },
  })
  return { client }
}

export function getAuthToken(request: Request): string | null {
  const cookies = request.headers.get('cookie') ?? ''
  for (const c of cookies.split(';')) {
    const [name, ...rest] = c.trim().split('=')
    if (name.trim() === 'sb-access-token') {
      return decodeURIComponent(rest.join('=').trim())
    }
  }
  return null
}

export async function getServerUser(token: string | undefined) {
  if (!token) return null
  const { client } = createSupabaseServerClient()
  const { data: { user } } = await client.auth.getUser(token)
  if (!user) return null
  const { data: profile } = await client.from('profiles').select('*').eq('id', user.id).single()
  return { user, profile }
}

export async function getAuthProfile(locals: Record<string, unknown>) {
  const token = locals.token as string | undefined
  if (!token) return null
  const { client } = createSupabaseServerClient()
  const { data: { user } } = await client.auth.getUser(token)
  if (!user) return null
  const { data: profile } = await client.from('profiles').select('*').eq('id', user.id).single()
  return profile
}

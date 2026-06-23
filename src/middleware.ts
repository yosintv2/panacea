import { createSupabaseServerClient } from './lib/supabase-server'
import type { Profile } from './types/profile'

export async function onRequest(context: { request: Request; locals: Record<string, unknown> }): Promise<Response | undefined> {
  const { pathname } = new URL(context.request.url)
  const publicPaths = ['/', '/login', '/pricing', '/contact', '/_astro']

  if (publicPaths.some(p => pathname.startsWith(p))) return

  const supabase = createSupabaseServerClient(context.request)
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return new Response(null, {
      status: 302,
      headers: { Location: '/login' },
    })
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single()

  context.locals.user = profile as Profile
}

import { supabase } from '../../lib/supabase'

export async function POST(): Promise<Response> {
  await supabase.auth.signOut()
  return new Response(null, {
    status: 302,
    headers: { Location: '/login' },
  })
}

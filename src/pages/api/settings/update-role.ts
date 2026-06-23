import { supabase } from '../../../lib/supabase'
import { createSupabaseServerClient } from '../../../lib/supabase-server'

export async function POST({ request }: { request: Request }): Promise<Response> {
  const supabaseServer = createSupabaseServerClient(request)
  const { data: { user: authUser } } = await supabaseServer.auth.getUser()
  if (!authUser) return new Response('Unauthorized', { status: 401 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', authUser.id)
    .single()

  if (profile?.role !== 'admin') return new Response('Forbidden', { status: 403 })

  const form = await request.formData()
  const userId = form.get('user_id') as string
  const role = form.get('role') as string

  if (!userId || !['admin', 'counsellor', 'staff'].includes(role)) {
    return new Response('Invalid request', { status: 400 })
  }

  await supabase.from('profiles').update({ role }).eq('id', userId)

  return new Response(null, {
    status: 302,
    headers: { Location: '/settings' },
  })
}

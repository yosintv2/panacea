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
  const email = (form.get('email') as string)?.trim().toLowerCase()

  if (!email) return new Response('Email required', { status: 400 })

  await supabase.from('admin_emails').delete().eq('email', email)

  return new Response(null, {
    status: 302,
    headers: { Location: '/settings' },
  })
}

import { getAuthToken, getServerUser, createSupabaseServerClient } from '../../../lib/supabase-server'

export async function POST({ request }: { request: Request }): Promise<Response> {
  const token = getAuthToken(request)
  if (!token) return new Response('Unauthorized', { status: 401 })

  const auth = await getServerUser(token)
  if (!auth?.profile || auth.profile.role !== 'admin') return new Response('Forbidden', { status: 403 })

  const form = await request.formData()
  const userId = form.get('user_id') as string
  const role = form.get('role') as string

  const { client: supabase } = createSupabaseServerClient()
  await supabase.from('profiles').update({ role }).eq('id', userId)

  return new Response(null, {
    status: 302,
    headers: { Location: '/settings' },
  })
}

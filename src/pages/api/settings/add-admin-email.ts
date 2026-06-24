import { getAuthToken, getServerUser, createSupabaseServerClient } from '../../../lib/supabase-server'

export async function POST({ request }: { request: Request }): Promise<Response> {
  const token = getAuthToken(request)
  if (!token) return new Response('Unauthorized', { status: 401 })

  const auth = await getServerUser(token)
  if (!auth?.profile || auth.profile.role !== 'admin') return new Response('Forbidden', { status: 403 })

  const form = await request.formData()
  const email = form.get('email') as string

  const { client: supabase } = createSupabaseServerClient()
  const { error } = await supabase.from('admin_emails').insert({ email })

  if (error) return new Response(error.message, { status: 400 })

  return new Response(null, {
    status: 302,
    headers: { Location: '/settings' },
  })
}

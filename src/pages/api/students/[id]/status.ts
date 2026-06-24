import { createSupabaseServerClient, getAuthToken } from '../../../../lib/supabase-server'

export async function POST({ params, request }: { params: { id: string }; request: Request }): Promise<Response> {
  const form = await request.formData()
  const status = form.get('status') as string
  const { id } = params

  const { client: supabase } = createSupabaseServerClient()

  const token = getAuthToken(request)
  let userId = '00000000-0000-0000-0000-000000000000'
  if (token) {
    const { data: { user } } = await supabase.auth.getUser(token)
    if (user) userId = user.id
  }

  const { error: updateError } = await supabase.from('students').update({ status, updated_at: new Date().toISOString() }).eq('id', id)
  if (updateError) {
    return new Response(updateError.message, { status: 400 })
  }

  const stageMap: Record<string, string> = {
    documents_pending: 'documents_collected',
    applied: 'applied',
    coe_received: 'coe_received',
    visa_approved: 'visa_approved',
    joined: 'arrived',
  }
  const stage = stageMap[status]
  if (stage) {
    const { error: insertError } = await supabase.from('student_journey').insert({
      student_id: id,
      stage,
      notes: `Status updated to ${status}`,
      created_by: userId,
    })
    if (insertError) {
      return new Response(insertError.message, { status: 400 })
    }
  }

  return new Response(null, {
    status: 302,
    headers: { Location: `/students/${id}` },
  })
}

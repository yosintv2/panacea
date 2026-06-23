import { supabase } from '../../../../lib/supabase'

export async function POST({ params, request }: { params: { id: string }; request: Request }): Promise<Response> {
  const form = await request.formData()
  const status = form.get('status') as string
  const { id } = params

  await supabase.from('students').update({ status, updated_at: new Date().toISOString() }).eq('id', id)

  await supabase.from('student_journey').insert({
    student_id: id,
    stage: status === 'documents_pending' ? 'documents_collected'
         : status === 'applied' ? 'applied'
         : status === 'coe_received' ? 'coe_received'
         : status === 'visa_approved' ? 'visa_approved'
         : status === 'joined' ? 'arrived'
         : status,
    notes: `Status updated to ${status}`,
    created_by: (await supabase.auth.getUser()).data.user?.id,
  })

  return new Response(null, {
    status: 302,
    headers: { Location: `/students/${id}` },
  })
}

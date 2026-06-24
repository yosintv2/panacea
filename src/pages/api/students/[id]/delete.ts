import type { APIRoute } from 'astro'
import { createSupabaseServerClient } from '../../../../lib/supabase-server'

export const POST: APIRoute = async ({ params, locals, redirect }) => {
  const { client: supabase } = createSupabaseServerClient()
  const token = locals.token as string | undefined
  if (!token) return redirect('/login')

  const { id } = params
  if (!id) return redirect('/students')

  await supabase.from('attendance_records').delete().eq('student_id', id)
  await supabase.from('group_students').delete().eq('student_id', id)
  await supabase.from('student_journey').delete().eq('student_id', id)
  await supabase.from('documents').delete().eq('student_id', id)
  await supabase.from('followups').delete().eq('student_id', id)
  await supabase.from('counselling').delete().eq('student_id', id)
  await supabase.from('students').delete().eq('id', id)

  return redirect('/students')
}

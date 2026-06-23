import { supabase } from '../../../lib/supabase'

export async function GET(): Promise<Response> {
  const { data: students } = await supabase.from('students').select('*').order('created_at', { ascending: false })

  if (!students) {
    return new Response('No data', { status: 404 })
  }

  const headers = ['Name', 'Mobile', 'Email', 'DOB', 'Address', 'Guardian', 'Guardian Mobile', 'Lead Source', 'Status', 'Branch', 'Created']
  const rows = students.map(s => [
    s.name,
    s.mobile,
    s.email ?? '',
    s.dob ?? '',
    s.address ?? '',
    s.guardian_name ?? '',
    s.guardian_mobile ?? '',
    s.lead_source,
    s.status,
    s.branch,
    new Date(s.created_at).toISOString().split('T')[0],
  ])

  const csv = [headers.join(','), ...rows.map(r => r.map(c => `"${String(c).replace(/"/g, '""')}"`).join(','))].join('\n')

  return new Response(csv, {
    headers: {
      'Content-Type': 'text/csv',
      'Content-Disposition': 'attachment; filename="students.csv"',
    },
  })
}

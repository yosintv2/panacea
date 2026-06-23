export type FollowupStatus = 'pending' | 'completed' | 'missed'

export interface Followup {
  id: string
  student_id: string
  assigned_to: string
  next_date: string
  note?: string
  status: FollowupStatus
  created_at: string
}

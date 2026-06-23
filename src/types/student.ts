export type StudentStatus =
  | 'lead'
  | 'documents_pending'
  | 'applied'
  | 'coe_received'
  | 'visa_approved'
  | 'joined'
  | 'cancelled'

export type LeadSource =
  | 'facebook'
  | 'tiktok'
  | 'website'
  | 'instagram'
  | 'walk_in'
  | 'friend_referral'
  | 'other'

export interface Student {
  id: string
  name: string
  mobile: string
  email?: string
  dob?: string
  address?: string
  guardian_name?: string
  guardian_mobile?: string
  guardian_relation?: string
  marks_grade?: string
  attendance?: number
  lead_source: LeadSource
  branch: string
  status: StudentStatus
  created_by: string
  created_at: string
  updated_at: string
}

export interface Counselling {
  id: string
  student_id: string
  counsellor_id: string
  referer_name?: string
  gpa?: string
  permanent_address?: string
  temporary_address?: string
  city_choice?: string
  country_interest?: string
  job_included: boolean
  qualification?: string
  passed_year?: number
  college_name?: string
  visa_type?: string
  contact_number?: string
  remarks?: string
  created_at: string
}

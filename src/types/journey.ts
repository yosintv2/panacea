export type JourneyStage =
  | 'inquiry'
  | 'counselling'
  | 'documents_collected'
  | 'applied'
  | 'interview'
  | 'coe_received'
  | 'visa_applied'
  | 'visa_approved'
  | 'arrived'

export interface StudentJourney {
  id: string
  student_id: string
  stage: JourneyStage
  notes?: string
  created_by: string
  created_at: string
}

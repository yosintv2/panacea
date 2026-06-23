export type DocumentType =
  | 'passport'
  | 'resume'
  | 'transcript'
  | 'photo'
  | 'visa'
  | 'offer_letter'
  | 'coe'
  | 'other'

export interface Document {
  id: string
  student_id: string
  type: DocumentType
  file_url: string
  file_name: string
  uploaded_by: string
  created_at: string
}

export type UserRole = 'admin' | 'counsellor' | 'staff'

export interface Profile {
  id: string
  email: string
  full_name: string
  role: UserRole
  branch: string
  avatar_url?: string
  created_at: string
}

-- ============================================================
-- Panacea CRM: Complete Migration
-- Run this in Supabase Dashboard SQL Editor
-- ============================================================

-- 1. Create a system user for data entry when no auth
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at)
VALUES ('00000000-0000-0000-0000-000000000000', 'system@panacea.local', crypt('system', gen_salt('bf')), now(), '{"full_name": "System User"}', now(), now())
ON CONFLICT (id) DO NOTHING;

-- 2. Create corresponding profile
INSERT INTO profiles (id, email, full_name, role, branch)
VALUES ('00000000-0000-0000-0000-000000000000', 'system@panacea.local', 'System User', 'admin', 'kathmandu')
ON CONFLICT (id) DO NOTHING;

-- 3. Disable RLS on all tables so anon key can work without auth
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE branches DISABLE ROW LEVEL SECURITY;
ALTER TABLE students DISABLE ROW LEVEL SECURITY;
ALTER TABLE counselling DISABLE ROW LEVEL SECURITY;
ALTER TABLE followups DISABLE ROW LEVEL SECURITY;
ALTER TABLE documents DISABLE ROW LEVEL SECURITY;
ALTER TABLE student_journey DISABLE ROW LEVEL SECURITY;
ALTER TABLE admin_emails DISABLE ROW LEVEL SECURITY;

-- 4. Drop RLS policies (cleanup, since RLS is disabled)
DROP POLICY IF EXISTS branch_isolation ON students;
DROP POLICY IF EXISTS branch_isolation ON counselling;
DROP POLICY IF EXISTS branch_isolation ON followups;
DROP POLICY IF EXISTS branch_isolation ON documents;
DROP POLICY IF EXISTS branch_isolation ON student_journey;

-- 5. Add missing columns to students table
ALTER TABLE students ADD COLUMN IF NOT EXISTS join_date DATE;
ALTER TABLE students ADD COLUMN IF NOT EXISTS attendance INTEGER;

-- 6. Add missing columns to counselling table
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS contact_number TEXT;
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS name TEXT;
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS mobile TEXT;
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS dob DATE;
-- Make student_id optional (counselling is pre-enrollment, separate from students)
ALTER TABLE counselling ALTER COLUMN student_id DROP NOT NULL;

-- 7. Backfill existing counselling records: copy referer_name → name, contact_number → mobile
UPDATE counselling SET name = referer_name WHERE name IS NULL AND referer_name IS NOT NULL;
UPDATE counselling SET mobile = contact_number WHERE mobile IS NULL AND contact_number IS NOT NULL;

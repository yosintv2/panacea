-- Run this in Supabase Dashboard SQL Editor
-- 1. Create a system user for data entry when no auth
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at)
VALUES ('00000000-0000-0000-0000-000000000000', 'system@panacea.local', crypt('system', gen_salt('bf')), now(), '{"full_name": "System User"}', now(), now())
ON CONFLICT (id) DO NOTHING;

-- 2. Create corresponding profile (auto-trigger should handle this, but just in case)
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

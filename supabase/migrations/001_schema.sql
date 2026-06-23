-- Profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'staff' CHECK (role IN ('admin', 'counsellor', 'staff')),
  branch TEXT NOT NULL DEFAULT 'kathmandu',
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Branches
CREATE TABLE branches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT,
  city TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE branches ENABLE ROW LEVEL SECURITY;

-- Students
CREATE TABLE students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  mobile TEXT NOT NULL,
  email TEXT,
  dob DATE,
  address TEXT,
  guardian_name TEXT,
  guardian_mobile TEXT,
  guardian_relation TEXT,
  marks_grade TEXT,
  attendance INTEGER,
  lead_source TEXT NOT NULL DEFAULT 'walk_in' CHECK (lead_source IN ('facebook','tiktok','website','instagram','walk_in','friend_referral','other')),
  branch TEXT NOT NULL DEFAULT 'kathmandu',
  status TEXT NOT NULL DEFAULT 'lead' CHECK (status IN ('lead','documents_pending','applied','coe_received','visa_approved','joined','cancelled')),
  created_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE students ENABLE ROW LEVEL SECURITY;

-- Counselling records
CREATE TABLE counselling (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  counsellor_id UUID NOT NULL REFERENCES profiles(id),
  referer_name TEXT,
  gpa TEXT,
  permanent_address TEXT,
  temporary_address TEXT,
  city_choice TEXT,
  country_interest TEXT DEFAULT 'Japan',
  job_included BOOLEAN NOT NULL DEFAULT false,
  qualification TEXT CHECK (qualification IN ('+2','bachelor','master','other')),
  passed_year INTEGER,
  college_name TEXT,
  visa_type TEXT,
  contact_number TEXT,
  remarks TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE counselling ENABLE ROW LEVEL SECURITY;

-- Follow-ups
CREATE TABLE followups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  assigned_to UUID NOT NULL REFERENCES profiles(id),
  next_date DATE NOT NULL,
  note TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','completed','missed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE followups ENABLE ROW LEVEL SECURITY;

-- Documents
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('passport','resume','transcript','photo','visa','offer_letter','coe','other')),
  file_url TEXT NOT NULL,
  file_name TEXT NOT NULL,
  uploaded_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Student Journey
CREATE TABLE student_journey (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  stage TEXT NOT NULL CHECK (stage IN ('inquiry','counselling','documents_collected','applied','interview','coe_received','visa_applied','visa_approved','arrived')),
  notes TEXT,
  created_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE student_journey ENABLE ROW LEVEL SECURITY;

-- Row Level Security: users see only their branch data
CREATE POLICY branch_isolation ON students
  FOR ALL USING (
    branch = (SELECT branch FROM profiles WHERE id = auth.uid())
    OR (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

CREATE POLICY branch_isolation ON counselling
  FOR ALL USING (
    student_id IN (SELECT id FROM students WHERE branch = (SELECT branch FROM profiles WHERE id = auth.uid()))
    OR (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

CREATE POLICY branch_isolation ON followups
  FOR ALL USING (
    student_id IN (SELECT id FROM students WHERE branch = (SELECT branch FROM profiles WHERE id = auth.uid()))
    OR (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

CREATE POLICY branch_isolation ON documents
  FOR ALL USING (
    student_id IN (SELECT id FROM students WHERE branch = (SELECT branch FROM profiles WHERE id = auth.uid()))
    OR (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

CREATE POLICY branch_isolation ON student_journey
  FOR ALL USING (
    student_id IN (SELECT id FROM students WHERE branch = (SELECT branch FROM profiles WHERE id = auth.uid()))
    OR (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role, branch)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data ->> 'full_name', new.email),
    'staff',
    'kathmandu'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

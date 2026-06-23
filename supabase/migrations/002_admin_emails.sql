-- Admin email whitelist: users signing up with these emails auto-get admin role
CREATE TABLE admin_emails (
  email TEXT PRIMARY KEY,
  added_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE admin_emails ENABLE ROW LEVEL SECURITY;

-- Only admins can view/manage the whitelist
CREATE POLICY admin_only ON admin_emails
  FOR ALL USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

-- Updated trigger: check admin_emails table on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
DECLARE
  assigned_role TEXT;
BEGIN
  -- Check if email is in admin whitelist
  IF EXISTS (SELECT 1 FROM public.admin_emails WHERE email = new.email) THEN
    assigned_role := 'admin';
  ELSE
    assigned_role := 'staff';
  END IF;

  INSERT INTO public.profiles (id, email, full_name, role, branch)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data ->> 'full_name', new.email),
    assigned_role,
    'kathmandu'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Seed data for Panacea CRM
-- Run this in the Supabase Dashboard SQL Editor

-- 1. Create auth users
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at)
VALUES
  ('a0000000-0000-0000-0000-000000000001', 'admin@panacea.com', crypt('admin123', gen_salt('bf')), now(), '{"full_name": "Admin User", "provider": "email"}', now(), now()),
  ('a0000000-0000-0000-0000-000000000002', 'counsellor@panacea.com', crypt('counsellor123', gen_salt('bf')), now(), '{"full_name": "Sita Sharma", "provider": "email"}', now(), now()),
  ('a0000000-0000-0000-0000-000000000003', 'staff@panacea.com', crypt('staff123', gen_salt('bf')), now(), '{"full_name": "Ram Thapa", "provider": "email"}', now(), now());

-- 2. Update auto-created profiles
UPDATE profiles SET role = 'admin', branch = 'kathmandu' WHERE id = 'a0000000-0000-0000-0000-000000000001';
UPDATE profiles SET role = 'counsellor', branch = 'kathmandu' WHERE id = 'a0000000-0000-0000-0000-000000000002';
UPDATE profiles SET role = 'staff', branch = 'pokhara' WHERE id = 'a0000000-0000-0000-0000-000000000003';

-- 3. Insert a branch
INSERT INTO branches (id, name, address, city, phone)
VALUES
  ('b0000000-0000-0000-0000-000000000001', 'Kathmandu Main', 'Durbar Marg', 'Kathmandu', '01-4XXXXXX'),
  ('b0000000-0000-0000-0000-000000000002', 'Pokhara Branch', 'Lakeside', 'Pokhara', '061-5XXXXXX');

-- 4. Insert sample students
INSERT INTO students (id, name, mobile, email, dob, address, guardian_name, guardian_mobile, guardian_relation, marks_grade, lead_source, branch, status, created_by, created_at)
VALUES
  ('s0000000-0000-0000-0000-000000000001', 'Bijay GC', '9841234567', 'bijay@example.com', '2002-05-15', 'Koteshwor, Kathmandu', 'Hari GC', '9841234560', 'Father', '3.2 GPA', 'facebook', 'kathmandu', 'lead', 'a0000000-0000-0000-0000-000000000001', now() - interval '10 days'),
  ('s0000000-0000-0000-0000-000000000002', 'Anjali Gurung', '9851234567', 'anjali@example.com', '2003-08-22', 'Pokhara-12', 'Maya Gurung', '9851234560', 'Mother', '85%', 'instagram', 'pokhara', 'applied', 'a0000000-0000-0000-0000-000000000003', now() - interval '8 days'),
  ('s0000000-0000-0000-0000-000000000003', 'Rabin Sharma', '9861234567', 'rabin@example.com', '2001-11-10', 'Baneshwor, Kathmandu', 'Krishna Sharma', '9861234560', 'Father', '3.8 GPA', 'walk_in', 'kathmandu', 'visa_approved', 'a0000000-0000-0000-0000-000000000001', now() - interval '15 days'),
  ('s0000000-0000-0000-0000-000000000004', 'Sunita Rai', '9871234567', 'sunita@example.com', '2002-03-05', 'Biratnagar-5', 'Dilip Rai', '9871234560', 'Father', '78%', 'tiktok', 'kathmandu', 'documents_pending', 'a0000000-0000-0000-0000-000000000001', now() - interval '5 days'),
  ('s0000000-0000-0000-0000-000000000005', 'Prakash Adhikari', '9881234567', 'prakash@example.com', '2000-07-18', 'Chitwan', 'Gopal Adhikari', '9881234560', 'Father', '3.5 GPA', 'friend_referral', 'pokhara', 'lead', 'a0000000-0000-0000-0000-000000000003', now() - interval '3 days'),
  ('s0000000-0000-0000-0000-000000000006', 'Mina Tamang', '9891234567', 'mina@example.com', '2003-01-30', 'Lalitpur', 'Sita Tamang', '9891234560', 'Mother', '82%', 'facebook', 'kathmandu', 'coe_received', 'a0000000-0000-0000-0000-000000000001', now() - interval '20 days');

-- 5. Insert counselling records (standalone, pre-enrollment)
INSERT INTO counselling (id, name, mobile, dob, counsellor_id, referer_name, gpa, permanent_address, temporary_address, city_choice, job_included, qualification, passed_year, visa_type, contact_number, remarks, created_at)
VALUES
  ('c0000000-0000-0000-0000-000000000001', 'Rita Sharma', '9841111111', '2002-05-15', 'a0000000-0000-0000-0000-000000000002', 'Facebook Ad', '3.2', 'Koteshwor, Kathmandu', 'Koteshwor, Kathmandu', 'Tokyo', false, '+2', 2022, 'SSW', '9841111111', 'Interested in SSW visa for Japan', now() - interval '7 days'),
  ('c0000000-0000-0000-0000-000000000002', 'Hari Bahadur Thapa', '9842222222', '2001-08-22', 'a0000000-0000-0000-0000-000000000002', 'Walk-in', '3.5', 'Pokhara, Nepal', 'Kathmandu, Nepal', 'Osaka', true, 'bachelor', 2023, 'student', '9842222222', 'Wants to study IT in Japan', now() - interval '5 days'),
  ('c0000000-0000-0000-0000-000000000003', 'Sita Devi Gurung', '9843333333', '2003-01-10', 'a0000000-0000-0000-0000-000000000002', 'Friend Referral', '2.8', 'Lalitpur, Nepal', 'Lalitpur, Nepal', 'Tokyo', true, '+2', 2021, 'SSW', '9843333333', 'Looking for work visa in Japan', now() - interval '12 days');

-- 6. Insert follow-ups
INSERT INTO followups (id, student_id, assigned_to, next_date, note, status, created_at)
VALUES
  ('f0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', CURRENT_DATE + interval '2 days', 'Call to check English class progress', 'pending', now()),
  ('f0000000-0000-0000-0000-000000000002', 's0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', CURRENT_DATE + interval '1 day', 'Follow up on pending documents', 'pending', now()),
  ('f0000000-0000-0000-0000-000000000003', 's0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', CURRENT_DATE - interval '2 days', 'Visa interview preparation', 'completed', now() - interval '3 days'),
  ('f0000000-0000-0000-0000-000000000004', 's0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', CURRENT_DATE + interval '5 days', 'Initial counselling follow-up', 'pending', now()),
  ('f0000000-0000-0000-0000-000000000005', 's0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', CURRENT_DATE, 'Application status update', 'pending', now());

-- 7. Insert student journey
INSERT INTO student_journey (id, student_id, stage, notes, created_by, created_at)
VALUES
  ('j0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000003', 'inquiry', 'Walk-in inquiry about Japan study', 'a0000000-0000-0000-0000-000000000001', now() - interval '30 days'),
  ('j0000000-0000-0000-0000-000000000002', 's0000000-0000-0000-0000-000000000003', 'counselling', 'Initial counselling completed', 'a0000000-0000-0000-0000-000000000002', now() - interval '25 days'),
  ('j0000000-0000-0000-0000-000000000003', 's0000000-0000-0000-0000-000000000003', 'documents_collected', 'All documents submitted', 'a0000000-0000-0000-0000-000000000001', now() - interval '20 days'),
  ('j0000000-0000-0000-0000-000000000004', 's0000000-0000-0000-0000-000000000003', 'applied', 'Application sent to Tokyo University', 'a0000000-0000-0000-0000-000000000001', now() - interval '15 days'),
  ('j0000000-0000-0000-0000-000000000005', 's0000000-0000-0000-0000-000000000003', 'coe_received', 'COE received', 'a0000000-0000-0000-0000-000000000001', now() - interval '5 days'),
  ('j0000000-0000-0000-0000-000000000006', 's0000000-0000-0000-0000-000000000006', 'inquiry', 'Facebook lead - interested in Nursing in Japan', 'a0000000-0000-0000-0000-000000000001', now() - interval '25 days'),
  ('j0000000-0000-0000-0000-000000000007', 's0000000-0000-0000-0000-000000000006', 'counselling', 'Counselled about nursing course', 'a0000000-0000-0000-0000-000000000002', now() - interval '22 days'),
  ('j0000000-0000-0000-0000-000000000008', 's0000000-0000-0000-0000-000000000006', 'coe_received', 'COE received from Japan Nursing College', 'a0000000-0000-0000-0000-000000000001', now() - interval '3 days');

-- 8. Add admin email to whitelist
INSERT INTO admin_emails (email)
VALUES ('admin@panacea.com')
ON CONFLICT DO NOTHING;

-- 9. Insert some sample documents
INSERT INTO documents (id, student_id, type, file_url, file_name, uploaded_by, created_at)
VALUES
  ('d0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000003', 'passport', '/files/rabin_passport.pdf', 'Passport.pdf', 'a0000000-0000-0000-0000-000000000001', now() - interval '20 days'),
  ('d0000000-0000-0000-0000-000000000002', 's0000000-0000-0000-0000-000000000003', 'transcript', '/files/rabin_transcript.pdf', 'Transcript.pdf', 'a0000000-0000-0000-0000-000000000001', now() - interval '20 days'),
  ('d0000000-0000-0000-0000-000000000003', 's0000000-0000-0000-0000-000000000003', 'resume', '/files/rabin_resume.pdf', 'Resume.pdf', 'a0000000-0000-0000-0000-000000000001', now() - interval '19 days');

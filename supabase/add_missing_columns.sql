-- Add missing columns to students table
ALTER TABLE students ADD COLUMN IF NOT EXISTS join_date DATE;
ALTER TABLE students ADD COLUMN IF NOT EXISTS attendance INTEGER;

-- Add missing columns to counselling table
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS contact_number TEXT;
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS name TEXT;
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS mobile TEXT;
ALTER TABLE counselling ADD COLUMN IF NOT EXISTS dob DATE;
-- Make student_id optional (counselling is pre-enrollment)
ALTER TABLE counselling ALTER COLUMN student_id DROP NOT NULL;

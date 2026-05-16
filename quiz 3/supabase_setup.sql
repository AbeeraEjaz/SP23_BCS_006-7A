-- ============================================================
--  CSC303 Quiz 3 — Supabase Table Setup
--  Run this SQL in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Create the submissions table
CREATE TABLE IF NOT EXISTS submissions (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  full_name   TEXT        NOT NULL,
  email       TEXT        NOT NULL,
  phone       TEXT        NOT NULL,
  address     TEXT        NOT NULL,
  gender      TEXT        NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- 3. Allow all operations (for development/testing)
CREATE POLICY "Allow all operations"
  ON submissions
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- 4. Auto-update updated_at timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- 5. Verify table was created
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'submissions';

-- Dagelijkse slaap & welzijn: uren slaap + cijfers (1-10) voor slaap, mood en lichaam
-- Run in Supabase → SQL Editor.
CREATE TABLE IF NOT EXISTS daily_wellness (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL DEFAULT auth.uid(),
  entry_date     date NOT NULL DEFAULT current_date,
  sleep_hours    numeric(3,1) NOT NULL CHECK (sleep_hours BETWEEN 0 AND 24),
  sleep_quality  integer NOT NULL CHECK (sleep_quality BETWEEN 1 AND 10),
  mood           integer NOT NULL CHECK (mood BETWEEN 1 AND 10),
  body           integer NOT NULL CHECK (body BETWEEN 1 AND 10),
  created_at     timestamptz DEFAULT now(),
  UNIQUE (user_id, entry_date)
);

-- Row level security
ALTER TABLE daily_wellness ENABLE ROW LEVEL SECURITY;

-- Spelers beheren hun eigen invoer (één per dag, bijwerken mag)
CREATE POLICY "Players read own wellness"
  ON daily_wellness FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Players insert own wellness"
  ON daily_wellness FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Players update own wellness"
  ON daily_wellness FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Admin kan alles lezen
CREATE POLICY "Admin reads all wellness"
  ON daily_wellness FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
    )
  );

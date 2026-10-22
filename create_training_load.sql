-- Trainingsbelasting (sRPE): minuten × hoe zwaar het voelde (1-10) = belasting in AU
-- Run in Supabase → SQL Editor.
CREATE TABLE IF NOT EXISTS training_load (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL DEFAULT auth.uid(),
  session_date  date NOT NULL DEFAULT current_date,
  session_type  text NOT NULL CHECK (session_type IN ('tennis', 'match', 'fysiek', 'overig')),
  duration_min  integer NOT NULL CHECK (duration_min BETWEEN 1 AND 600),
  rpe           integer NOT NULL CHECK (rpe BETWEEN 1 AND 10),
  load_au       integer GENERATED ALWAYS AS (duration_min * rpe) STORED,
  notes         text,
  created_at    timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS training_load_user_date ON training_load (user_id, session_date);

-- Row level security
ALTER TABLE training_load ENABLE ROW LEVEL SECURITY;

-- Spelers beheren hun eigen sessies
CREATE POLICY "Players read own load"
  ON training_load FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Players insert own load"
  ON training_load FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Players delete own load"
  ON training_load FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- Admin kan alle sessies lezen
CREATE POLICY "Admin reads all load"
  ON training_load FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
    )
  );

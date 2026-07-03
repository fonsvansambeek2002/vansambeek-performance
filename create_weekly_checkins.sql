-- Maak weekly_checkins tabel aan
CREATE TABLE IF NOT EXISTS weekly_checkins (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  week_start       date NOT NULL,
  overall_rating   integer CHECK (overall_rating BETWEEN 1 AND 10),
  training_sessions integer,
  mental_training  integer CHECK (mental_training BETWEEN 1 AND 10),
  mental_matches   integer CHECK (mental_matches BETWEEN 1 AND 10),
  energy_level     integer CHECK (energy_level BETWEEN 1 AND 10),
  sleep_recovery   integer CHECK (sleep_recovery BETWEEN 1 AND 10),
  went_well        text,
  was_challenging  text,
  focus_next_week  text,
  created_at       timestamptz DEFAULT now(),
  UNIQUE(user_id, week_start)
);

-- Row level security
ALTER TABLE weekly_checkins ENABLE ROW LEVEL SECURITY;

-- Spelers kunnen hun eigen check-ins invoegen
CREATE POLICY "Players insert own checkins"
  ON weekly_checkins FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Spelers kunnen hun eigen check-ins lezen
CREATE POLICY "Players read own checkins"
  ON weekly_checkins FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- Admin kan alle check-ins lezen
CREATE POLICY "Admin reads all checkins"
  ON weekly_checkins FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
    )
  );

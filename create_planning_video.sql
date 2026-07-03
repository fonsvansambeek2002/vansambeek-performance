-- ── TOERNOOIPLANNING ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tournaments (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name        text NOT NULL,
  location    text,
  surface     text,
  start_date  date NOT NULL,
  end_date    date,
  notes       text,
  created_at  timestamptz DEFAULT now()
);

ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Players insert own tournaments"
  ON tournaments FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Players select own tournaments"
  ON tournaments FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Players delete own tournaments"
  ON tournaments FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admin selects all tournaments"
  ON tournaments FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));


-- ── VIDEO ANALYSE ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS video_submissions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title       text NOT NULL,
  video_url   text NOT NULL,
  video_type  text,
  description text,
  feedback    text,
  created_at  timestamptz DEFAULT now()
);

ALTER TABLE video_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Players insert own videos"
  ON video_submissions FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Players select own videos"
  ON video_submissions FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admin selects all videos"
  ON video_submissions FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));

CREATE POLICY "Admin updates video feedback"
  ON video_submissions FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));

-- Scouting: tegenstanders met sterke/zwakke punten en tactiek
-- Run in Supabase → SQL Editor.
CREATE TABLE IF NOT EXISTS opponent_scouts (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL DEFAULT auth.uid(),
  name        text NOT NULL,
  club        text,
  ranking     text,
  hand        text CHECK (hand IN ('rechts', 'links')),
  backhand    text CHECK (backhand IN ('enkel', 'dubbel')),
  play_style  text,
  strengths   text,
  weaknesses  text,
  game_plan   text,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS opponent_scouts_user ON opponent_scouts (user_id, updated_at DESC);
ALTER TABLE opponent_scouts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Players read own scouts" ON opponent_scouts;
CREATE POLICY "Players read own scouts" ON opponent_scouts FOR SELECT TO authenticated
  USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Players insert own scouts" ON opponent_scouts;
CREATE POLICY "Players insert own scouts" ON opponent_scouts FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Players update own scouts" ON opponent_scouts;
CREATE POLICY "Players update own scouts" ON opponent_scouts FOR UPDATE TO authenticated
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Players delete own scouts" ON opponent_scouts;
CREATE POLICY "Players delete own scouts" ON opponent_scouts FOR DELETE TO authenticated
  USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Admin reads all scouts" ON opponent_scouts;
CREATE POLICY "Admin reads all scouts" ON opponent_scouts FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));

select '✓ Klaar' as status;

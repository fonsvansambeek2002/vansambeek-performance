-- Focus: aandachtspunten per onderdeel (speler én coach kunnen ze toevoegen)
-- Run in Supabase → SQL Editor.
CREATE TABLE IF NOT EXISTS focus_points (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category    text NOT NULL CHECK (category IN ('forehand', 'backhand', 'service', 'return', 'volley', 'tactisch', 'fysiek', 'mentaal')),
  text        text NOT NULL,
  done        boolean NOT NULL DEFAULT false,
  created_by  uuid REFERENCES auth.users(id) ON DELETE SET NULL DEFAULT auth.uid(),
  created_at  timestamptz DEFAULT now(),
  done_at     timestamptz
);
CREATE INDEX IF NOT EXISTS focus_points_user ON focus_points (user_id, category);
ALTER TABLE focus_points ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Own or admin read focus" ON focus_points;
CREATE POLICY "Own or admin read focus" ON focus_points FOR SELECT TO authenticated
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));
DROP POLICY IF EXISTS "Own or admin insert focus" ON focus_points;
CREATE POLICY "Own or admin insert focus" ON focus_points FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));
DROP POLICY IF EXISTS "Own or admin update focus" ON focus_points;
CREATE POLICY "Own or admin update focus" ON focus_points FOR UPDATE TO authenticated
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));
DROP POLICY IF EXISTS "Own or admin delete focus" ON focus_points;
CREATE POLICY "Own or admin delete focus" ON focus_points FOR DELETE TO authenticated
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));

select '✓ Klaar' as status;

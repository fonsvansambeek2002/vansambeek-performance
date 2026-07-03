-- ── STORAGE BUCKET ───────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public, file_size_limit)
VALUES ('player-videos', 'player-videos', false, 524288000)  -- 500 MB max
ON CONFLICT (id) DO NOTHING;

-- Spelers mogen video's uploaden naar hun eigen map
CREATE POLICY "Players upload own videos"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'player-videos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Spelers mogen hun eigen video's bekijken
CREATE POLICY "Players view own videos"
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'player-videos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Admin mag alle video's bekijken
CREATE POLICY "Admin view all player videos"
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'player-videos'
    AND EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
  );


-- ── SCHEMA UPDATE ─────────────────────────────────────────────────
-- Voeg storage_path kolom toe en maak video_url optioneel
ALTER TABLE video_submissions
  ADD COLUMN IF NOT EXISTS storage_path text;

ALTER TABLE video_submissions
  ALTER COLUMN video_url DROP NOT NULL;

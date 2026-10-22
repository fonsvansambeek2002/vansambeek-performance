-- Alle openstaande updates in één keer. Plak in Supabase → SQL Editor → Run.
-- Veilig om vaker te draaien.

-- ═══ 1. Beveiliging: spelers kunnen zichzelf geen admin meer maken ═══
-- Security fixes — run in Supabase → SQL Editor.
--
-- 1. PROBLEEM: de policy "Profiles are updatable by owner" laat elke ingelogde gebruiker
--    zijn eigen profielrij bijwerken, inclusief is_admin. Een speler kan zichzelf dus
--    beheerder maken (één regel in de browserconsole) en daarmee alle klantdata zien.
--    De app zelf werkt profielen nooit bij, dus beperken we updates tot full_name.

revoke update on public.profiles from authenticated, anon;
grant update (full_name) on public.profiles to authenticated;

-- ═══ 2. Trainingsbelasting ═══
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
DROP POLICY IF EXISTS "Players read own load" ON training_load;
CREATE POLICY "Players read own load"
  ON training_load FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Players insert own load" ON training_load;
CREATE POLICY "Players insert own load"
  ON training_load FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Players delete own load" ON training_load;
CREATE POLICY "Players delete own load"
  ON training_load FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- Admin kan alle sessies lezen
DROP POLICY IF EXISTS "Admin reads all load" ON training_load;
CREATE POLICY "Admin reads all load"
  ON training_load FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
    )
  );


-- ═══ 3. Slaap & welzijn ═══
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
DROP POLICY IF EXISTS "Players read own wellness" ON daily_wellness;
CREATE POLICY "Players read own wellness"
  ON daily_wellness FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Players insert own wellness" ON daily_wellness;
CREATE POLICY "Players insert own wellness"
  ON daily_wellness FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Players update own wellness" ON daily_wellness;
CREATE POLICY "Players update own wellness"
  ON daily_wellness FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Admin kan alles lezen
DROP POLICY IF EXISTS "Admin reads all wellness" ON daily_wellness;
CREATE POLICY "Admin reads all wellness"
  ON daily_wellness FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
    )
  );


select '✓ Klaar' as status;
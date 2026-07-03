CREATE TABLE IF NOT EXISTS assignment_completions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  assignment_num  integer NOT NULL,
  response        text NOT NULL,
  created_at      timestamptz DEFAULT now(),
  UNIQUE(user_id, assignment_num)
);

ALTER TABLE assignment_completions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Players insert own completions"
  ON assignment_completions FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Players read own completions"
  ON assignment_completions FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admin reads all completions"
  ON assignment_completions FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));

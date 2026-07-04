ALTER TABLE content_items
  ADD COLUMN IF NOT EXISTS title_en       text,
  ADD COLUMN IF NOT EXISTS description_en text;

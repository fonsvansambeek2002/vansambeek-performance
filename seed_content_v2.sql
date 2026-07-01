-- Verwijder alle bestaande content items
DELETE FROM content_items;

-- Voeg nieuwe content items in
INSERT INTO content_items (title, description, category, video_url, published, sort_order) VALUES
(
  'Peak Mental Performance',
  'Justin Sua werkt al meer dan 10 jaar met de beste atleten ter wereld. In dit gesprek deelt hij zijn strategieën voor mentale prestaties — zelfvertrouwen, consistentie, omgaan met druk en het verschil tussen talent en succes.',
  'mentaal',
  'https://www.youtube.com/watch?v=uVuwTbiApUk',
  true,
  1
),
(
  'Get Better — Mental Performance',
  'Justin Sua legt uit hoe je jezelf mentaal kunt verbeteren als atleet. Praktisch, direct en toepasbaar op je training en wedstrijden.',
  'mentaal',
  'https://www.youtube.com/watch?v=zdCwsuVC9iw',
  true,
  2
),
(
  'Hoe professionele struggles jou helpen',
  'Justin Sua bespreekt hoe de mentale uitdagingen van professionele tennissers direct relevant zijn voor elke ambitieuze speler.',
  'mentaal',
  'https://www.youtube.com/watch?v=TjP-m708RRU',
  true,
  3
),
(
  'Guided Meditation for Athletes',
  'Een begeleide meditatie van 10 minuten speciaal ontworpen voor atleten. Helpt je focussen, kalmeren en je geest klaren voor training of wedstrijd.',
  'mindfulness',
  'https://www.youtube.com/watch?v=Z2dK_m2LfrY',
  true,
  4
),
(
  'Yoga For Tennis Players — Yoga With Adriene',
  'Adriene''s yoga flow speciaal voor tennissers. Gericht op schouders, heupen en polsen — de gebieden die het meest belast worden tijdens tennis.',
  'fysiek',
  'https://www.youtube.com/watch?v=bfFXJq9MMYs',
  true,
  5
),
(
  'Yoga for Tennis — Mobility & Recovery',
  'Een complete yoga flow voor mobiliteit, stabiliteit en herstel. Perfect na een zware training of wedstrijd.',
  'fysiek',
  'https://www.youtube.com/watch?v=RH4utG2J9nw',
  true,
  6
);

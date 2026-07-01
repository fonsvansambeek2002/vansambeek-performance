-- Verwijder alle bestaande content items
DELETE FROM content_items;

-- Voeg nieuwe content items in
INSERT INTO content_items (title, description, category, video_url, published, sort_order) VALUES
(
  'Full Body Gentle Yoga for Athletes',
  '22 minuten zachte yoga speciaal voor atleten. Perfect voor herstel en actieve rustdagen. Van Breathe and Flow — een van de beste yoga kanalen op YouTube.',
  'fysiek',
  'https://www.youtube.com/watch?v=B4kNiCWTl7M',
  true,
  1
),
(
  'Yoga For Tennis Players',
  'Speciaal ontworpen voor tennissers. Gericht op schouders, heupen en polsen — de plekken die het meest belast worden tijdens tennis. Van Yoga With Adriene, 13 miljoen subscribers.',
  'fysiek',
  'https://www.youtube.com/watch?v=bfFXJq9MMYs',
  true,
  2
),
(
  'Yoga for Tennis — Mobility & Recovery',
  'Complete yoga flow voor mobiliteit, stabiliteit en herstel na een zware training of wedstrijd.',
  'fysiek',
  'https://www.youtube.com/watch?v=RH4utG2J9nw',
  true,
  3
),
(
  'Peak Mental Performance',
  'Justin Sua werkt meer dan 10 jaar met de beste atleten ter wereld. Hij deelt zijn strategieën voor zelfvertrouwen, consistentie en omgaan met druk.',
  'mentaal',
  'https://www.youtube.com/watch?v=uVuwTbiApUk',
  true,
  4
),
(
  'Get Better — Mental Performance',
  'Justin Sua legt uit hoe je jezelf mentaal kunt verbeteren als atleet. Praktisch en direct toepasbaar.',
  'mentaal',
  'https://www.youtube.com/watch?v=zdCwsuVC9iw',
  true,
  5
),
(
  'Hoe professionele struggles jou helpen',
  'Hoe de mentale uitdagingen van professionele tennissers direct relevant zijn voor elke ambitieuze speler.',
  'mentaal',
  'https://www.youtube.com/watch?v=TjP-m708RRU',
  true,
  6
),
(
  'Guided Meditation for Athletes',
  '10 minuten begeleide meditatie speciaal voor atleten. Helpt je focussen en je geest klaren voor training of wedstrijd.',
  'mindfulness',
  'https://www.youtube.com/watch?v=Z2dK_m2LfrY',
  true,
  7
),
(
  'Ontbijt 1 — Havermout met banaan',
  '80g havermout, 300ml melk, 1 banaan, 1 el honing, handvol noten. Kook havermout met melk, voeg banaan toe, druppel honing en strooi noten. Eet 1,5-2 uur voor training. Geeft stabiele energie zonder crash.',
  'voeding',
  null,
  true,
  8
),
(
  'Ontbijt 2 — Eieren met avocado toast',
  '2 eieren, 1 snee volkorenbrood, halve avocado, zout en peper. Bak de eieren, prak avocado op het brood, leg eieren erop. Hoog in eiwitten en gezonde vetten. Perfect voor een zware trainingsdag.',
  'voeding',
  null,
  true,
  9
),
(
  'Lunch 1 — Kip rijst bowl',
  '150g kipfilet, 100g rijst, komkommer, tomaat, olijfolie, citroensap. Grill de kip, kook rijst, snij groenten. Combineer alles in een bowl met olijfolie en citroensap. Veel eiwitten, goede koolhydraten.',
  'voeding',
  null,
  true,
  10
),
(
  'Lunch 2 — Tonijn wrap',
  '1 tortilla, 1 blik tonijn, sla, tomaat, komkommer, Griekse yoghurt. Meng tonijn met yoghurt, vul de wrap met sla en groenten. Snel klaar, veel eiwitten, perfect tussen trainingen door.',
  'voeding',
  null,
  true,
  11
),
(
  'Diner 1 — Zalm met zoete aardappel',
  '150g zalm, 1 zoete aardappel, broccoli, olijfolie, knoflook. Bak zalm in olijfolie met knoflook, rooster zoete aardappel in oven, stoom broccoli. Omega-3 van de zalm helpt herstel na intensieve training.',
  'voeding',
  null,
  true,
  12
),
(
  'Diner 2 — Pasta met groenten en kip',
  '150g volkoren pasta, 150g kip, paprika, courgette, tomatensaus. Kook pasta, bak kip met groenten, voeg tomatensaus toe. Veel koolhydraten voor herstel na wedstrijd. Eet dit de avond voor een toernooi.',
  'voeding',
  null,
  true,
  13
);

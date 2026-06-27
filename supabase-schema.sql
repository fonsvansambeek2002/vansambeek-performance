-- Eenmalig uitvoeren in de Supabase SQL editor van dit project.

create extension if not exists pgcrypto;

-- Profielen (1-op-1 met auth.users). is_admin bepaalt toegang tot admin.html.
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

alter table profiles add column if not exists is_admin boolean not null default false;

alter table profiles enable row level security;

drop policy if exists "Profiles are viewable by owner" on profiles;
create policy "Profiles are viewable by owner" on profiles
  for select using (auth.uid() = id);

drop policy if exists "Profiles are updatable by owner" on profiles;
create policy "Profiles are updatable by owner" on profiles
  for update using (auth.uid() = id);

-- Admins kunnen alle profielen zien (nodig voor match_reflections overzicht).
drop policy if exists "Admins can view all profiles" on profiles;
create policy "Admins can view all profiles" on profiles
  for select using (
    exists (select 1 from profiles where id = auth.uid() and is_admin = true)
  );

-- Coachingsessies per atleet.
create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  athlete_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  session_date timestamptz not null,
  notes text,
  status text not null default 'gepland' check (status in ('gepland', 'voltooid', 'geannuleerd')),
  created_at timestamptz not null default now()
);

alter table sessions enable row level security;

drop policy if exists "Athletes see their own sessions" on sessions;
create policy "Athletes see their own sessions" on sessions
  for select using (auth.uid() = athlete_id);

-- Content bibliotheek, per categorie. Alleen admins mogen schrijven.
alter table if exists content rename to content_items;

create table if not exists content_items (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('mentaal', 'mindfulness', 'voeding', 'fysiek')),
  title text not null,
  description text,
  video_url text,
  published boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

-- Bijwerken check constraint op bestaande tabel.
alter table if exists content_items drop constraint if exists content_items_category_check;
alter table if exists content_items add constraint content_items_category_check
  check (category in ('mentaal', 'mindfulness', 'voeding', 'fysiek'));

do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_name = 'content_items' and column_name = 'media_url'
  ) then
    alter table content_items rename column media_url to video_url;
  end if;
end $$;

alter table content_items add column if not exists published boolean not null default true;
alter table content_items add column if not exists sort_order integer not null default 0;
alter table content_items drop column if exists body;
alter table content_items drop column if exists type;

alter table content_items enable row level security;

drop policy if exists "Content is readable by authenticated users" on content_items;
create policy "Content is readable by authenticated users" on content_items
  for select using (auth.role() = 'authenticated');

drop policy if exists "Only admins can insert content" on content_items;
create policy "Only admins can insert content" on content_items
  for insert with check (
    exists (select 1 from profiles where id = auth.uid() and is_admin = true)
  );

drop policy if exists "Only admins can update content" on content_items;
create policy "Only admins can update content" on content_items
  for update using (
    exists (select 1 from profiles where id = auth.uid() and is_admin = true)
  );

drop policy if exists "Only admins can delete content" on content_items;
create policy "Only admins can delete content" on content_items
  for delete using (
    exists (select 1 from profiles where id = auth.uid() and is_admin = true)
  );

-- Wedstrijdreflecties per atleet.
create table if not exists match_reflections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  datum date not null,
  tegenstander text not null,
  score text,
  vraag1 text,
  vraag2 text,
  vraag3 text,
  created_at timestamptz not null default now()
);

alter table match_reflections enable row level security;

drop policy if exists "Athletes see own reflections" on match_reflections;
create policy "Athletes see own reflections" on match_reflections
  for select using (auth.uid() = user_id);

drop policy if exists "Athletes insert own reflections" on match_reflections;
create policy "Athletes insert own reflections" on match_reflections
  for insert with check (auth.uid() = user_id);

drop policy if exists "Admins see all reflections" on match_reflections;
create policy "Admins see all reflections" on match_reflections
  for select using (
    exists (select 1 from profiles where id = auth.uid() and is_admin = true)
  );

-- Na het aanmaken van je eigen account (via Supabase Auth of de inlogpagina),
-- maak je eigen profiel-rij aan en zet 'is_admin' op true, bijv.:
-- insert into profiles (id, full_name, is_admin) values ('<jouw-auth-user-id>', 'Fons van Sambeek', true)
--   on conflict (id) do update set is_admin = true;

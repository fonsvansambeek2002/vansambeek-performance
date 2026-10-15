-- Security fixes — run in Supabase → SQL Editor.
--
-- 1. PROBLEEM: de policy "Profiles are updatable by owner" laat elke ingelogde gebruiker
--    zijn eigen profielrij bijwerken, inclusief is_admin. Een speler kan zichzelf dus
--    beheerder maken (één regel in de browserconsole) en daarmee alle klantdata zien.
--    De app zelf werkt profielen nooit bij, dus beperken we updates tot full_name.

revoke update on public.profiles from authenticated, anon;
grant update (full_name) on public.profiles to authenticated;

-- 2. CONTROLE: welke policies staan er op de gevoelige tabellen?
--    Verwachting: payments / client_programs / coach_notes alleen schrijfbaar voor admins,
--    en spelers mogen alleen hun eigen rijen lezen.

select tablename, policyname, cmd, roles, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in ('profiles', 'payments', 'client_programs', 'coach_notes')
order by tablename, cmd;

-- Staat RLS überhaupt aan op deze tabellen? (rowsecurity moet true zijn)
select relname as tablename, relrowsecurity as rowsecurity
from pg_class
where relnamespace = 'public'::regnamespace
  and relname in ('profiles', 'payments', 'client_programs', 'coach_notes');

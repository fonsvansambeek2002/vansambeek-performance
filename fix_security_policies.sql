-- Beveiliging voor payments, client_programs en coach_notes.
-- Spelers: alleen hun eigen rijen LEZEN. Beheerders: alles lezen en schrijven.
-- Veilig om meerdere keren uit te voeren. Bestaande policies op deze drie tabellen worden vervangen.

-- Hulpfunctie: is de ingelogde gebruiker beheerder?
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select is_admin from public.profiles where id = auth.uid()), false);
$$;

-- Oude policies op deze tabellen weghalen (wat er ook stond)
do $$
declare p record;
begin
  for p in
    select tablename, policyname from pg_policies
    where schemaname = 'public' and tablename in ('payments', 'client_programs', 'coach_notes')
  loop
    execute format('drop policy %I on public.%I', p.policyname, p.tablename);
  end loop;
end $$;

alter table public.payments        enable row level security;
alter table public.client_programs enable row level security;
alter table public.coach_notes     enable row level security;

-- client_programs
create policy "programs: eigen lezen" on public.client_programs
  for select to authenticated using (user_id = auth.uid());
create policy "programs: admin alles" on public.client_programs
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- payments
create policy "payments: eigen lezen" on public.payments
  for select to authenticated using (user_id = auth.uid());
create policy "payments: admin alles" on public.payments
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- coach_notes
create policy "notes: eigen lezen" on public.coach_notes
  for select to authenticated using (client_id = auth.uid());
create policy "notes: admin alles" on public.coach_notes
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Controle: dit moet 6 regels tonen
select tablename, policyname, cmd from pg_policies
where schemaname = 'public' and tablename in ('payments', 'client_programs', 'coach_notes')
order by tablename, policyname;

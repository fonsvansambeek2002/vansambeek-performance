-- Agenda: coach zet vrije momenten klaar, klanten boeken een gesprek.
-- Veilig om opnieuw te draaien.

create table if not exists coach_slots (
  id uuid primary key default gen_random_uuid(),
  start_at timestamptz not null,
  duration_min int not null default 60 check (duration_min between 10 and 240),
  location text,
  booked_by uuid references auth.users(id) on delete set null,
  booked_at timestamptz,
  booking_note text,
  created_at timestamptz default now()
);
create index if not exists coach_slots_start_idx on coach_slots (start_at);

alter table coach_slots enable row level security;

-- klanten zien alleen vrije momenten en hun eigen gesprekken; de coach ziet alles
drop policy if exists "coach_slots read" on coach_slots;
create policy "coach_slots read" on coach_slots for select to authenticated
  using (booked_by is null or booked_by = auth.uid()
         or exists (select 1 from profiles where id = auth.uid() and is_admin = true));

-- alleen de coach maakt, wijzigt en verwijdert momenten
drop policy if exists "coach_slots admin write" on coach_slots;
create policy "coach_slots admin write" on coach_slots for all to authenticated
  using (exists (select 1 from profiles where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from profiles where id = auth.uid() and is_admin = true));

-- boeken en annuleren gaat via functies, zodat twee klanten nooit hetzelfde moment krijgen
create or replace function book_slot(p_slot uuid, p_note text default null)
returns void language plpgsql security definer set search_path = public as $$
begin
  update coach_slots
     set booked_by = auth.uid(), booked_at = now(), booking_note = nullif(trim(p_note), '')
   where id = p_slot and booked_by is null and start_at > now();
  if not found then
    raise exception 'Dit moment is al geboekt of niet meer beschikbaar.';
  end if;
end $$;

create or replace function cancel_slot(p_slot uuid)
returns void language plpgsql security definer set search_path = public as $$
begin
  update coach_slots
     set booked_by = null, booked_at = null, booking_note = null
   where id = p_slot and booked_by = auth.uid() and start_at > now();
  if not found then
    raise exception 'Dit gesprek kan niet meer geannuleerd worden.';
  end if;
end $$;

revoke all on function book_slot(uuid, text) from public, anon;
revoke all on function cancel_slot(uuid) from public, anon;
grant execute on function book_slot(uuid, text) to authenticated;
grant execute on function cancel_slot(uuid) to authenticated;

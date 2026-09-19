-- Cuentas: esquema de base de datos para Supabase.
-- Pégalo entero en Supabase → SQL Editor → New query → Run.
-- Se puede ejecutar más de una vez sin romper nada.

-- Una fila por "documento" de cada usuario:
--   cuentas:settings        (categorías, reglas, límite, tema)
--   cuentas:month:YYYY-MM   (movimientos de ese mes)
create table if not exists public.user_data (
  user_id    uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  key        text        not null,
  value      text        not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, key),
  constraint user_data_key_ok   check (key ~ '^cuentas:(settings|month:[0-9]{4}-[0-9]{2})$'),
  constraint user_data_size_ok  check (length(value) <= 1000000)
);

-- Seguridad a nivel de fila: cada persona solo ve y toca lo suyo.
alter table public.user_data enable row level security;

drop policy if exists "user_data_select_own" on public.user_data;
drop policy if exists "user_data_insert_own" on public.user_data;
drop policy if exists "user_data_update_own" on public.user_data;
drop policy if exists "user_data_delete_own" on public.user_data;

create policy "user_data_select_own" on public.user_data
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "user_data_insert_own" on public.user_data
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "user_data_update_own" on public.user_data
  for update to authenticated
  using      ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "user_data_delete_own" on public.user_data
  for delete to authenticated
  using ((select auth.uid()) = user_id);

-- Sin sesión iniciada no se puede tocar nada.
revoke all on public.user_data from anon;
grant select, insert, update, delete on public.user_data to authenticated;

-- Mantiene updated_at al día en cada modificación.
create or replace function public.user_data_touch()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists user_data_touch on public.user_data;
create trigger user_data_touch
  before update on public.user_data
  for each row execute function public.user_data_touch();

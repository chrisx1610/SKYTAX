-- Catálogo remoto de aeronaves SkyTax.
-- El usuario administrador continúa guardándose y validándose localmente.

create table public.airports (
  code text primary key check (code = upper(code) and length(code) between 3 and 8),
  name text not null,
  created_at timestamptz not null default now()
);

create table public.operators (
  id bigint generated always as identity primary key,
  airport_code text not null references public.airports(code) on delete cascade,
  name text not null,
  rif text,
  unique (airport_code, name)
);

create table public.aircraft (
  airport_code text not null references public.airports(code) on delete cascade,
  id text not null,
  model text not null,
  operator_id bigint references public.operators(id) on delete set null,
  capacity integer check (capacity is null or capacity >= 0),
  primary key (airport_code, id)
);

-- La aplicación inicia una sesión anónima de Supabase para proteger las
-- tablas de accesos públicos. Activa Anonymous Sign-Ins en Authentication.
alter table public.airports enable row level security;
alter table public.operators enable row level security;
alter table public.aircraft enable row level security;

create policy "authenticated users read airports"
on public.airports for select to authenticated using (true);
create policy "authenticated users read operators"
on public.operators for select to authenticated using (true);
create policy "authenticated users manage operators"
on public.operators for all to authenticated using (true) with check (true);
create policy "authenticated users read aircraft"
on public.aircraft for select to authenticated using (true);
create policy "authenticated users manage aircraft"
on public.aircraft for all to authenticated using (true) with check (true);

insert into public.airports (code, name) values ('SVMI', 'Maiquetía');
insert into public.operators (airport_code, name, rif) values
  ('SVMI', 'Conviasa', 'G-20007774-3'),
  ('SVMI', 'Avior Airlines', 'J-30093868-6'),
  ('SVMI', 'Laser Airlines', 'J-30276836-5'),
  ('SVMI', 'Estelar Latinoamerica', 'J-30902333-4');
insert into public.aircraft (airport_code, id, model, operator_id, capacity)
select 'SVMI', fleet.registration, fleet.model, operators.id, fleet.capacity
from (values
  ('YV1234', 'AC90', 'Conviasa', 7),
  ('YV2850', 'Embraer E190', 'Conviasa', 104),
  ('YV3016', 'Boeing 737-200', 'Avior Airlines', 120),
  ('YV3224', 'Airbus A340-300', 'Conviasa', 250),
  ('YV1004', 'McDonnell Douglas MD-82', 'Laser Airlines', 147),
  ('YV3389', 'Boeing 737-300', 'Estelar Latinoamerica', 140)
) as fleet(registration, model, operator_name, capacity)
join public.operators on operators.airport_code = 'SVMI' and operators.name = fleet.operator_name;

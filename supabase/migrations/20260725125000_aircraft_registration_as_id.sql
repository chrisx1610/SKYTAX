-- La columna id contendrá la matrícula de la aeronave (por ejemplo, YV4567).
-- Conserva las filas existentes y elimina el identificador numérico interno.

alter table public.aircraft
  drop constraint if exists aircraft_pkey;

alter table public.aircraft
  drop constraint if exists aircraft_airport_code_registration_key;

alter table public.aircraft
  drop column if exists id;

alter table public.aircraft
  rename column registration to id;

alter table public.aircraft
  add constraint aircraft_pkey primary key (airport_code, id);

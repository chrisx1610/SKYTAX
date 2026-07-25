-- Las filas de aircraft representan exclusivamente aeronaves con hangar.
-- La ausencia de una matrícula implica aeronave foránea y recargo DOSA.
alter table public.aircraft drop column if exists has_hangar;

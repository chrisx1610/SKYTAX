-- Limpieza de la migración inicial anterior.
-- Úsala solo si se ejecutó 20260725120000_initial_schema.sql y no hay datos
-- reales que conservar. Elimina únicamente tablas de prueba de SkyTax.

drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user() cascade;
drop function if exists public.next_invoice_sequence(text) cascade;
drop function if exists public.is_admin() cascade;

drop table if exists public.audit_log cascade;
drop table if exists public.invoices cascade;
drop table if exists public.invoice_sequences cascade;
drop table if exists public.settings cascade;
drop table if exists public.aircraft cascade;
drop table if exists public.operators cascade;
drop table if exists public.profiles cascade;
drop table if exists public.airports cascade;

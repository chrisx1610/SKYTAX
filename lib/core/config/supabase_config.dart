/// Configuración pública de Supabase.
///
/// La clave publicable es apta para clientes; la protección de los datos se
/// aplica mediante las políticas RLS de la base de datos.
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://guwbltpxdjiwjwjhuopx.supabase.co',
  );
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_LyiBY-bqHI_qTEMOxl-6yg_F9z2OX2L',
  );
}

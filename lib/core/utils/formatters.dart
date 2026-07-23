import 'package:intl/intl.dart';

/// Formateadores compartidos para montos, fechas y horas.
class Formatters {
  Formatters._();

  static final NumberFormat _money = NumberFormat('#,##0.##', 'en_US');

  /// Formatea un monto como `€1,425` (sin decimales cuando son cero).
  static String money(double value) => '€${_money.format(value)}';

  static String date(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  static String time(DateTime dt) => DateFormat('HH:mm').format(dt);

  static String dateTime(DateTime dt) =>
      DateFormat('dd/MM/yyyy HH:mm').format(dt);

  /// Número de factura con relleno de ceros: `FACT-000001`.
  static String invoiceNumber(int sequence) =>
      'FACT-${sequence.toString().padLeft(6, '0')}';
}

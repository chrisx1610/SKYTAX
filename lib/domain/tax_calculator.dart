import '../data/models/models.dart';

/// Resultado del cálculo de impuestos para una consulta.
class TaxQuote {
  const TaxQuote({
    required this.registration,
    required this.aircraftModel,
    required this.operatorName,
    required this.passengers,
    required this.taxRate,
    required this.taxSubtotal,
    required this.dosa,
    required this.total,
    required this.isLocal,
  });

  final String registration;
  final String aircraftModel;

  /// Nombre del operador según la base de datos, o `null` si la aeronave
  /// no está registrada en este aeropuerto.
  final String? operatorName;
  final int passengers;

  /// Tasa aeroportuaria por pasajero.
  final double taxRate;

  /// Tasa aeroportuaria × cantidad de pasajeros.
  final double taxSubtotal;

  /// Monto DOSA aplicado (0 si la aeronave es local).
  final double dosa;
  final double total;

  /// `true` si la matrícula existe en la base de datos del aeropuerto.
  final bool isLocal;

  bool get hasDosa => dosa > 0;
}

/// Algoritmo de cálculo de impuestos aeroportuarios.
///
/// Regla 1: si la matrícula existe en la base de datos local, la aeronave
/// pertenece a este aeropuerto y solo paga `tasa × pasajeros`.
///
/// Regla 2: si la matrícula no existe, la aeronave pertenece a otro
/// aeropuerto y paga además la DOSA de forma automática. El operador nunca
/// selecciona los impuestos manualmente.
class TaxCalculator {
  const TaxCalculator();

  TaxQuote quote({
    required String registration,
    required String typedModel,
    required int passengers,
    required Aircraft? aircraft,
    required double taxRate,
    required double dosaFee,
  }) {
    if (passengers <= 0) {
      throw ArgumentError.value(
          passengers, 'passengers', 'Debe ser mayor que cero');
    }
    final bool isLocal = aircraft != null;
    final double subtotal = taxRate * passengers;
    final double dosa = isLocal ? 0 : dosaFee;
    return TaxQuote(
      registration: registration.trim().toUpperCase(),
      aircraftModel:
          isLocal ? aircraft.model : typedModel.trim(),
      operatorName: aircraft?.operatorName,
      passengers: passengers,
      taxRate: taxRate,
      taxSubtotal: subtotal,
      dosa: dosa,
      total: subtotal + dosa,
      isLocal: isLocal,
    );
  }
}

/// Modelos de datos de SkyTax.
library;

/// Aeronave registrada en la base de datos del aeropuerto.
class Aircraft {
  const Aircraft({
    this.id,
    required this.registration,
    required this.model,
    this.operatorId,
    this.operatorName,
    this.capacity,
  });

  final int? id;
  final String registration;
  final String model;
  final int? operatorId;
  final String? operatorName;
  final int? capacity;

  factory Aircraft.fromMap(Map<String, Object?> map) => Aircraft(
        id: map['id'] as int?,
        registration: map['registration'] as String,
        model: map['model'] as String,
        operatorId: map['operator_id'] as int?,
        operatorName: map['operator_name'] as String?,
        capacity: map['capacity'] as int?,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'registration': registration,
        'model': model,
        'operator_id': operatorId,
        'capacity': capacity,
      };
}

/// Operador aéreo (aerolínea o explotador).
class AirOperator {
  const AirOperator({this.id, required this.name, this.rif});

  final int? id;
  final String name;
  final String? rif;

  factory AirOperator.fromMap(Map<String, Object?> map) => AirOperator(
        id: map['id'] as int?,
        name: map['name'] as String,
        rif: map['rif'] as String?,
      );

  Map<String, Object?> toMap() => {'id': id, 'name': name, 'rif': rif};
}

/// Usuario del sistema (administrador u operador de kiosco).
class AppUser {
  const AppUser({
    this.id,
    required this.username,
    required this.fullName,
    required this.role,
  });

  static const String roleAdmin = 'admin';
  static const String roleOperator = 'operator';

  final int? id;
  final String username;
  final String fullName;
  final String role;

  bool get isAdmin => role == roleAdmin;

  factory AppUser.fromMap(Map<String, Object?> map) => AppUser(
        id: map['id'] as int?,
        username: map['username'] as String,
        fullName: map['full_name'] as String,
        role: map['role'] as String,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'username': username,
        'full_name': fullName,
        'role': role,
      };
}

/// Factura emitida por el sistema.
class Invoice {
  const Invoice({
    this.id,
    required this.number,
    required this.createdAt,
    required this.airportCode,
    required this.airportName,
    required this.registration,
    required this.aircraftModel,
    required this.operatorName,
    required this.passengers,
    required this.taxRate,
    required this.taxSubtotal,
    required this.dosa,
    required this.total,
    required this.paymentMethod,
    required this.filePath,
    required this.createdBy,
  });

  static const String methodCard = 'card';
  static const String methodMobile = 'mobile';

  final int? id;
  final String number;
  final DateTime createdAt;
  final String airportCode;
  final String airportName;
  final String registration;
  final String aircraftModel;
  final String operatorName;
  final int passengers;
  final double taxRate;
  final double taxSubtotal;
  final double dosa;
  final double total;
  final String paymentMethod;
  final String filePath;
  final String createdBy;

  bool get hasDosa => dosa > 0;

  factory Invoice.fromMap(Map<String, Object?> map) => Invoice(
        id: map['id'] as int?,
        number: map['number'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        airportCode: map['airport_code'] as String,
        airportName: map['airport_name'] as String,
        registration: map['registration'] as String,
        aircraftModel: map['aircraft_model'] as String,
        operatorName: map['operator_name'] as String,
        passengers: map['passengers'] as int,
        taxRate: (map['tax_rate'] as num).toDouble(),
        taxSubtotal: (map['tax_subtotal'] as num).toDouble(),
        dosa: (map['dosa'] as num).toDouble(),
        total: (map['total'] as num).toDouble(),
        paymentMethod: map['payment_method'] as String,
        filePath: map['file_path'] as String,
        createdBy: map['created_by'] as String,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'number': number,
        'created_at': createdAt.toIso8601String(),
        'airport_code': airportCode,
        'airport_name': airportName,
        'registration': registration,
        'aircraft_model': aircraftModel,
        'operator_name': operatorName,
        'passengers': passengers,
        'tax_rate': taxRate,
        'tax_subtotal': taxSubtotal,
        'dosa': dosa,
        'total': total,
        'payment_method': paymentMethod,
        'file_path': filePath,
        'created_by': createdBy,
      };

  Invoice copyWith({int? id, String? filePath}) => Invoice(
        id: id ?? this.id,
        number: number,
        createdAt: createdAt,
        airportCode: airportCode,
        airportName: airportName,
        registration: registration,
        aircraftModel: aircraftModel,
        operatorName: operatorName,
        passengers: passengers,
        taxRate: taxRate,
        taxSubtotal: taxSubtotal,
        dosa: dosa,
        total: total,
        paymentMethod: paymentMethod,
        filePath: filePath ?? this.filePath,
        createdBy: createdBy,
      );
}

/// Registro de auditoría: quién hizo qué, cuándo y desde qué aeropuerto.
class AuditEntry {
  const AuditEntry({
    this.id,
    required this.createdAt,
    required this.username,
    required this.action,
    required this.details,
    required this.airportCode,
  });

  final int? id;
  final DateTime createdAt;
  final String username;
  final String action;
  final String details;
  final String airportCode;

  factory AuditEntry.fromMap(Map<String, Object?> map) => AuditEntry(
        id: map['id'] as int?,
        createdAt: DateTime.parse(map['created_at'] as String),
        username: map['username'] as String,
        action: map['action'] as String,
        details: map['details'] as String,
        airportCode: map['airport_code'] as String,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'username': username,
        'action': action,
        'details': details,
        'airport_code': airportCode,
      };
}

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../core/logging/app_logger.dart';

/// Acceso a la base de datos SQLite de SkyTax.
///
/// Cada aeropuerto tiene una base de datos independiente
/// (`skytax_<codigo>.db`) que almacena únicamente las aeronaves cuya base
/// operacional corresponde a ese aeropuerto, además de su configuración,
/// usuarios, facturas y auditoría.
class SkyTaxDatabase {
  SkyTaxDatabase({required this.dataDirectory});

  /// Directorio donde se guardan los archivos `.db`.
  final String dataDirectory;

  Database? _db;
  String? _openedCode;

  Database get database {
    final Database? db = _db;
    if (db == null) {
      throw StateError('La base de datos no ha sido abierta.');
    }
    return db;
  }

  static String hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  /// Abre (o crea) la base de datos del aeropuerto indicado.
  Future<Database> open(String airportCode) async {
    final String code = airportCode.trim().toUpperCase();
    if (_db != null && _openedCode == code) return _db!;
    await _db?.close();
    _db = null;

    await Directory(dataDirectory).create(recursive: true);
    final String path =
        p.join(dataDirectory, 'skytax_${code.toLowerCase()}.db');

    _db = await openDatabase(
      path,
      version: 2,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) => _createSchema(db, code),
      onUpgrade: _upgrade,
    );
    _openedCode = code;
    AppLogger.instance.info('Base de datos abierta: $path');
    return _db!;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _openedCode = null;
  }

  /// Migraciones entre versiones del esquema.
  Future<void> _upgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // v2: el administrador inicial pasa de admin/admin123 a
      // Vincent/123456789. Solo se reemplaza si el usuario aún conserva
      // las credenciales de fábrica (no pisa cambios hechos desde el panel).
      await db.update(
        'users',
        {
          'username': 'Vincent',
          'password_hash': hashPassword('123456789'),
        },
        where: 'username = ? AND password_hash = ?',
        whereArgs: ['admin', hashPassword('admin123')],
      );
    }
  }

  Future<void> _createSchema(Database db, String airportCode) async {
    await db.execute('''
      CREATE TABLE operators(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        rif TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE aircraft(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        registration TEXT NOT NULL UNIQUE,
        model TEXT NOT NULL,
        operator_id INTEGER REFERENCES operators(id) ON DELETE SET NULL,
        capacity INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        password_hash TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE invoices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        airport_code TEXT NOT NULL,
        airport_name TEXT NOT NULL,
        registration TEXT NOT NULL,
        aircraft_model TEXT NOT NULL,
        operator_name TEXT NOT NULL,
        passengers INTEGER NOT NULL,
        tax_rate REAL NOT NULL,
        tax_subtotal REAL NOT NULL,
        dosa REAL NOT NULL,
        total REAL NOT NULL,
        payment_method TEXT NOT NULL,
        file_path TEXT NOT NULL,
        created_by TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE settings(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE audit_log(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at TEXT NOT NULL,
        username TEXT NOT NULL,
        action TEXT NOT NULL,
        details TEXT NOT NULL,
        airport_code TEXT NOT NULL
      )
    ''');

    await _seed(db, airportCode);
  }

  /// Datos iniciales: configuración, usuario administrador y operadores.
  /// Las aeronaves de demostración solo se cargan para SVMI (Maiquetía).
  Future<void> _seed(Database db, String airportCode) async {
    const Map<String, String> defaults = {
      'tax_rate': '15',
      'dosa_fee': '120',
      'invoice_seq': '1',
    };
    for (final MapEntry<String, String> entry in defaults.entries) {
      await db.insert('settings', {'key': entry.key, 'value': entry.value});
    }

    await db.insert('users', {
      'username': 'Vincent',
      'full_name': 'Administrador del Sistema',
      'role': 'admin',
      'password_hash': hashPassword('123456789'),
    });

    final Map<String, int> operatorIds = {};
    const List<Map<String, String>> operators = [
      {'name': 'Conviasa', 'rif': 'G-20007774-3'},
      {'name': 'Avior Airlines', 'rif': 'J-30093868-6'},
      {'name': 'Laser Airlines', 'rif': 'J-30276836-5'},
      {'name': 'Estelar Latinoamerica', 'rif': 'J-30902333-4'},
    ];
    for (final Map<String, String> op in operators) {
      operatorIds[op['name']!] = await db.insert('operators', op);
    }

    if (airportCode == 'SVMI') {
      const List<(String, String, String, int)> fleet = [
        ('YV1234', 'AC90', 'Conviasa', 7),
        ('YV2850', 'Embraer E190', 'Conviasa', 104),
        ('YV3016', 'Boeing 737-200', 'Avior Airlines', 120),
        ('YV3224', 'Airbus A340-300', 'Conviasa', 250),
        ('YV1004', 'McDonnell Douglas MD-82', 'Laser Airlines', 147),
        ('YV3389', 'Boeing 737-300', 'Estelar Latinoamerica', 140),
      ];
      for (final (String reg, String model, String op, int cap) in fleet) {
        await db.insert('aircraft', {
          'registration': reg,
          'model': model,
          'operator_id': operatorIds[op],
          'capacity': cap,
        });
      }
    }

    await db.insert('audit_log', {
      'created_at': DateTime.now().toIso8601String(),
      'username': 'sistema',
      'action': 'DB_CREATED',
      'details': 'Base de datos creada para el aeropuerto $airportCode',
      'airport_code': airportCode,
    });
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Catálogo de aeronaves almacenado en Supabase por aeropuerto.
class SupabaseAircraftRepository {
  SupabaseAircraftRepository(this._client, this._airportCode);

  final SupabaseClient _client;
  final String Function() _airportCode;

  Future<List<Aircraft>> getAll() async {
    final rows = await _client
        .from('aircraft')
        .select('id, registration, model, operator_id, capacity, operators(name)')
        .eq('airport_code', _airportCode())
        .order('registration');
    return (rows as List).cast<Map<String, dynamic>>().map(_fromRow).toList();
  }

  Future<Aircraft?> findByRegistration(String registration) async {
    final row = await _client
        .from('aircraft')
        .select('id, registration, model, operator_id, capacity, operators(name)')
        .eq('airport_code', _airportCode())
        .eq('registration', registration.trim().toUpperCase())
        .maybeSingle();
    return row == null ? null : _fromRow(row);
  }

  Future<bool> registrationExists(String registration, {int? excludeId}) async {
    var query = _client
        .from('aircraft')
        .select('id')
        .eq('airport_code', _airportCode())
        .eq('registration', registration.trim().toUpperCase());
    if (excludeId != null) query = query.neq('id', excludeId);
    return (await query as List).isNotEmpty;
  }

  Future<int> insert(Aircraft aircraft) async {
    final row = await _client
        .from('aircraft')
        .insert(await _toRow(aircraft))
        .select('id')
        .single();
    return (row['id'] as num).toInt();
  }

  Future<void> update(Aircraft aircraft) async {
    await _client.from('aircraft').update(await _toRow(aircraft)).eq('id', aircraft.id!);
  }

  Future<void> delete(int id) => _client.from('aircraft').delete().eq('id', id);

  Future<Map<String, Object?>> _toRow(Aircraft aircraft) async => {
        'airport_code': _airportCode(),
        'registration': aircraft.registration.trim().toUpperCase(),
        'model': aircraft.model.trim(),
        'operator_id': await _operatorId(aircraft.operatorName),
        'capacity': aircraft.capacity,
      };

  Future<int?> _operatorId(String? name) async {
    final String operatorName = name?.trim() ?? '';
    if (operatorName.isEmpty) return null;
    final existing = await _client
        .from('operators')
        .select('id')
        .eq('airport_code', _airportCode())
        .eq('name', operatorName)
        .maybeSingle();
    if (existing != null) return (existing['id'] as num).toInt();
    final created = await _client
        .from('operators')
        .insert({'airport_code': _airportCode(), 'name': operatorName})
        .select('id')
        .single();
    return (created['id'] as num).toInt();
  }

  Aircraft _fromRow(Map<String, dynamic> row) {
    final dynamic operatorRow = row['operators'];
    return Aircraft(
      id: (row['id'] as num).toInt(),
      registration: row['registration'] as String,
      model: row['model'] as String,
      operatorId: (row['operator_id'] as num?)?.toInt(),
      operatorName: operatorRow is Map<String, dynamic>
          ? operatorRow['name'] as String?
          : null,
      capacity: (row['capacity'] as num?)?.toInt(),
    );
  }
}

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
        .select('id, model, operator_id, capacity, operators(name)')
        .eq('airport_code', _airportCode())
        .order('id');
    return (rows as List).cast<Map<String, dynamic>>().map(_fromRow).toList();
  }

  Future<Aircraft?> findByRegistration(String registration) async {
    final row = await _client
        .from('aircraft')
        .select('id, model, operator_id, capacity, operators(name)')
        .eq('airport_code', _airportCode())
        .eq('id', registration.trim().toUpperCase())
        .maybeSingle();
    return row == null ? null : _fromRow(row);
  }

  Future<bool> registrationExists(
    String registration, {
    String? excludeRegistration,
  }) async {
    var query = _client
        .from('aircraft')
        .select('id')
        .eq('airport_code', _airportCode())
        .eq('id', registration.trim().toUpperCase());
    if (excludeRegistration != null) {
      query = query.neq(
        'id',
        excludeRegistration.trim().toUpperCase(),
      );
    }
    return (await query as List).isNotEmpty;
  }

  Future<void> insert(Aircraft aircraft) async {
    await _client.from('aircraft').insert(await _toRow(aircraft));
  }

  Future<void> update(
    Aircraft aircraft, {
    required String originalRegistration,
  }) async {
    await _client
        .from('aircraft')
        .update(await _toRow(aircraft))
        .eq('airport_code', _airportCode())
        .eq('id', originalRegistration.trim().toUpperCase());
  }

  Future<void> delete(String registration) => _client
      .from('aircraft')
      .delete()
      .eq('airport_code', _airportCode())
      .eq('id', registration.trim().toUpperCase());

  Future<Map<String, Object?>> _toRow(Aircraft aircraft) async => {
        'airport_code': _airportCode(),
        'id': aircraft.registration.trim().toUpperCase(),
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
      registration: row['id'] as String,
      model: row['model'] as String,
      operatorId: (row['operator_id'] as num?)?.toInt(),
      operatorName: operatorRow is Map<String, dynamic>
          ? operatorRow['name'] as String?
          : null,
      capacity: (row['capacity'] as num?)?.toInt(),
    );
  }
}

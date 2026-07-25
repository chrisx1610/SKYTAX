import 'package:flutter/material.dart';

import '../../core/app_paths.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/logging/app_logger.dart';
import '../../core/utils/formatters.dart';
import '../../data/database/skytax_database.dart';
import '../../data/local_config.dart';
import '../../data/models/models.dart';
import '../../data/repositories/supabase_aircraft_repository.dart';
import '../../data/repositories/audit_repository.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/invoicing.dart';
import '../../domain/payment_simulator.dart';
import '../../domain/tax_calculator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Estado global de la aplicación.
///
/// Orquesta la configuración local, la base de datos del aeropuerto, los
/// repositorios y los servicios de dominio (cálculo, pago y facturación).
class AppController extends ChangeNotifier {
  AppController({required this.paths}) {
    _dbase = SkyTaxDatabase(dataDirectory: paths.data);
    _configStore = LocalConfigStore(baseDirectory: paths.base);
    aircraft = SupabaseAircraftRepository(Supabase.instance.client, () => config.airportCode);
    users = UserRepository(_dbase);
    invoices = InvoiceRepository(_dbase);
    settings = SettingsRepository(_dbase);
    auditLog = AuditRepository(_dbase);
    invoiceOutput = TxtInvoiceOutput(directory: paths.facturas);
  }

  final AppPaths paths;

  late final SkyTaxDatabase _dbase;
  late final LocalConfigStore _configStore;

  late final SupabaseAircraftRepository aircraft;
  late final UserRepository users;
  late final InvoiceRepository invoices;
  late final SettingsRepository settings;
  late final AuditRepository auditLog;

  /// Puerto de emisión de facturas (implementación TXT para la demo).
  late final InvoiceOutput invoiceOutput;

  static const TaxCalculator calculator = TaxCalculator();
  final PaymentSimulator payments = const PaymentSimulator();

  LocalConfig config = LocalConfig.defaults;
  AppStrings strings = AppStrings.es;
  Locale locale = const Locale('es');
  double taxRate = 15;
  double dosaFee = 120;
  AppUser? currentAdmin;

  /// Usuario registrado en la auditoría para la operación actual.
  String get auditUser => currentAdmin?.username ?? 'kiosco';

  Future<void> bootstrap() async {
    config = await _configStore.load();
    await _dbase.open(config.airportCode);
    if (Supabase.instance.client.auth.currentSession == null) {
      await Supabase.instance.client.auth.signInAnonymously();
    }
    await _reloadSettings();
    AppLogger.instance
        .info('SkyTax iniciado en ${config.airportDisplay}');
  }

  Future<void> _reloadSettings() async {
    taxRate = await settings.getDouble(SettingsRepository.keyTaxRate, 15);
    dosaFee = await settings.getDouble(SettingsRepository.keyDosaFee, 120);
  }

  void setLanguage(String code) {
    strings = code == 'en' ? AppStrings.en : AppStrings.es;
    locale = Locale(code == 'en' ? 'en' : 'es');
    notifyListeners();
  }

  Future<void> audit(String action, String details) async {
    try {
      await auditLog.log(AuditEntry(
        createdAt: DateTime.now(),
        username: auditUser,
        action: action,
        details: details,
        airportCode: config.airportCode,
      ));
    } catch (e, st) {
      AppLogger.instance.error('No se pudo registrar auditoría', e, st);
    }
  }

  /// Busca la matrícula en la base de datos local y calcula los impuestos
  /// según las reglas de negocio (DOSA automática para aeronaves foráneas).
  Future<TaxQuote> consult({
    required String registration,
    required String typedModel,
    required int passengers,
  }) async {
    await _reloadSettings();
    final Aircraft? found = await aircraft.findByRegistration(registration);
    final TaxQuote quote = calculator.quote(
      registration: registration,
      typedModel: typedModel,
      passengers: passengers,
      aircraft: found,
      taxRate: taxRate,
      dosaFee: dosaFee,
    );
    AppLogger.instance.info(
      'Consulta ${quote.registration}: '
      '${quote.isLocal ? 'local' : 'foránea (DOSA)'} — '
      'total ${quote.total.toStringAsFixed(2)}',
    );
    return quote;
  }

  /// Registra el pago: asigna número de factura, emite el documento a través
  /// del puerto de salida, persiste la factura y deja rastro de auditoría.
  Future<Invoice> finalizeSale(TaxQuote quote, String paymentMethod) async {
    final int seq = await settings.nextInvoiceSequence();
    final DateTime now = DateTime.now();
    Invoice invoice = Invoice(
      number: Formatters.invoiceNumber(seq),
      createdAt: now,
      airportCode: config.airportCode,
      airportName: config.airportName,
      registration: quote.registration,
      aircraftModel: quote.aircraftModel,
      operatorName: quote.operatorName ?? strings.notRegistered,
      passengers: quote.passengers,
      taxRate: quote.taxRate,
      taxSubtotal: quote.taxSubtotal,
      dosa: quote.dosa,
      total: quote.total,
      paymentMethod: paymentMethod,
      filePath: '',
      createdBy: auditUser,
    );
    final String path = await invoiceOutput.emit(invoice, strings);
    invoice = invoice.copyWith(filePath: path);
    await invoices.insert(invoice);
    await audit(
      'PAGO',
      'Factura ${invoice.number} — ${invoice.registration} — '
          '${strings.paymentMethodName(paymentMethod)} — '
          'total ${Formatters.money(invoice.total)}',
    );
    AppLogger.instance.info('Factura generada: $path');
    return invoice;
  }

  Future<bool> adminLogin(String username, String password) async {
    final AppUser? user = await users.authenticate(username, password);
    if (user == null || !user.isAdmin) {
      await audit('LOGIN_FALLIDO', 'Intento de acceso con usuario "$username"');
      return false;
    }
    currentAdmin = user;
    await audit('LOGIN', 'Acceso al panel administrativo');
    notifyListeners();
    return true;
  }

  Future<void> adminLogout() async {
    await audit('LOGOUT', 'Salida del panel administrativo');
    currentAdmin = null;
    notifyListeners();
  }

  /// Actualiza en memoria los datos del administrador autenticado
  /// (tras editar su nombre o usuario desde el panel).
  void refreshCurrentAdmin(AppUser user) {
    if (currentAdmin?.id == user.id) {
      currentAdmin = user;
      notifyListeners();
    }
  }

  Future<void> updateRates({
    required double newTaxRate,
    required double newDosaFee,
  }) async {
    await settings.set(SettingsRepository.keyTaxRate, '$newTaxRate');
    await settings.set(SettingsRepository.keyDosaFee, '$newDosaFee');
    await audit(
      'CONFIGURACION',
      'Tasa aeroportuaria: $newTaxRate USD — DOSA: $newDosaFee USD',
    );
    await _reloadSettings();
    notifyListeners();
  }

  /// Cambia el aeropuerto del terminal: guarda la configuración local y abre
  /// (o crea) la base de datos independiente de ese aeropuerto.
  Future<void> changeAirport(String code, String name) async {
    config = LocalConfig(
      airportCode: code.trim().toUpperCase(),
      airportName: name.trim(),
    );
    await _configStore.save(config);
    await _dbase.open(config.airportCode);
    await _reloadSettings();
    await audit('AEROPUERTO', 'Terminal asignado a ${config.airportDisplay}');
    notifyListeners();
  }
}

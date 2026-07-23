import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/i18n/app_strings.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/utils/input_formatters.dart';
import '../../state/app_controller.dart';

/// Configuración de tarifas y del aeropuerto del terminal.
class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late final TextEditingController _taxRate;
  late final TextEditingController _dosaFee;
  late final TextEditingController _airportCode;
  late final TextEditingController _airportName;
  bool _savingRates = false;
  bool _savingAirport = false;

  @override
  void initState() {
    super.initState();
    final AppController controller = context.read<AppController>();
    _taxRate = TextEditingController(text: '${controller.taxRate}');
    _dosaFee = TextEditingController(text: '${controller.dosaFee}');
    _airportCode =
        TextEditingController(text: controller.config.airportCode);
    _airportName =
        TextEditingController(text: controller.config.airportName);
  }

  @override
  void dispose() {
    _taxRate.dispose();
    _dosaFee.dispose();
    _airportCode.dispose();
    _airportName.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveRates() async {
    final AppController controller = context.read<AppController>();
    final AppStrings s = controller.strings;
    final double? taxRate = double.tryParse(_taxRate.text.trim());
    final double? dosaFee = double.tryParse(_dosaFee.text.trim());
    if (taxRate == null || taxRate <= 0 || dosaFee == null || dosaFee < 0) {
      _snack(s.invalidNumber);
      return;
    }
    setState(() => _savingRates = true);
    try {
      await controller.updateRates(newTaxRate: taxRate, newDosaFee: dosaFee);
      if (mounted) _snack(s.settingsSaved);
    } catch (e, st) {
      AppLogger.instance.error('No se pudo guardar la configuración', e, st);
      if (mounted) _snack(s.errorGeneric);
    } finally {
      if (mounted) setState(() => _savingRates = false);
    }
  }

  Future<void> _saveAirport() async {
    final AppController controller = context.read<AppController>();
    final AppStrings s = controller.strings;
    final String code = _airportCode.text.trim().toUpperCase();
    final String name = _airportName.text.trim();
    if (code.isEmpty || name.isEmpty) {
      _snack(s.requiredField);
      return;
    }
    setState(() => _savingAirport = true);
    try {
      await controller.changeAirport(code, name);
      _taxRate.text = '${controller.taxRate}';
      _dosaFee.text = '${controller.dosaFee}';
      if (mounted) _snack(s.settingsSaved);
    } catch (e, st) {
      AppLogger.instance.error('No se pudo cambiar el aeropuerto', e, st);
      if (mounted) _snack(s.errorGeneric);
    } finally {
      if (mounted) setState(() => _savingAirport = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.watch<AppController>().strings;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.sectionSettings,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _taxRate,
                        style: const TextStyle(fontSize: 20),
                        keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                        decoration:
                            InputDecoration(labelText: s.taxRateField),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _dosaFee,
                        style: const TextStyle(fontSize: 20),
                        keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                        decoration: InputDecoration(labelText: s.dosaField),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.save_rounded),
                          label: Text(s.save),
                          onPressed: _savingRates ? null : _saveRates,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _airportCode,
                        style: const TextStyle(fontSize: 20),
                        inputFormatters: [UpperCaseTextFormatter()],
                        decoration: InputDecoration(
                            labelText: s.airportCodeField, hintText: 'SVMI'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _airportName,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            labelText: s.airportNameField,
                            hintText: 'Maiquetía'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.airportChangedNote,
                        style: TextStyle(
                            fontSize: 14, color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.swap_horiz_rounded),
                          label: Text(s.save),
                          onPressed: _savingAirport ? null : _saveAirport,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

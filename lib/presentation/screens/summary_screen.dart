import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/i18n/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../domain/tax_calculator.dart';
import '../state/app_controller.dart';
import '../widgets/kiosk_widgets.dart';
import 'payment_method_screen.dart';

/// Resumen del cálculo antes de pagar.
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.quote});

  final TaxQuote quote;

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final AppStrings s = controller.strings;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return KioskScaffold(
      title: s.summaryTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatusChip(
            icon: quote.isLocal
                ? Icons.home_work_rounded
                : Icons.connecting_airports_rounded,
            label: quote.isLocal ? s.localAircraftNote : s.foreignAircraftNote,
            background: quote.isLocal
                ? scheme.secondaryContainer
                : scheme.tertiaryContainer,
            foreground: quote.isLocal
                ? scheme.onSecondaryContainer
                : scheme.onTertiaryContainer,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                children: [
                  SummaryRow(
                      label: s.registrationShort, value: quote.registration),
                  SummaryRow(label: s.modelLabel, value: quote.aircraftModel),
                  SummaryRow(
                      label: s.passengersShort, value: '${quote.passengers}'),
                  const Divider(height: 24),
                  SummaryRow(
                    label:
                        '${s.airportTaxLabel} (${quote.passengers} × ${Formatters.money(quote.taxRate)})',
                    value: Formatters.money(quote.taxSubtotal),
                  ),
                  if (quote.hasDosa)
                    SummaryRow(
                        label: s.dosaLabel,
                        value: Formatters.money(quote.dosa)),
                  const Divider(height: 24),
                  SummaryRow(
                    label: s.totalToPay,
                    value: Formatters.money(quote.total),
                    emphasized: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          KioskActionBar(
            secondaryLabel: s.cancel,
            onSecondary: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            primaryLabel: s.continueLabel,
            primaryIcon: Icons.arrow_forward_rounded,
            onPrimary: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PaymentMethodScreen(quote: quote),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

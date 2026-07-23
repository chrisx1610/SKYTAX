import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tesis/core/i18n/app_strings.dart';
import 'package:tesis/core/theme/app_theme.dart';
import 'package:tesis/core/utils/formatters.dart';
import 'package:tesis/data/models/models.dart';
import 'package:tesis/domain/invoicing.dart';
import 'package:tesis/domain/tax_calculator.dart';
import 'package:tesis/presentation/widgets/kiosk_widgets.dart';

void main() {
  const TaxCalculator calculator = TaxCalculator();
  const Aircraft localAircraft = Aircraft(
    id: 1,
    registration: 'YV1234',
    model: 'AC90',
    operatorName: 'Conviasa',
  );

  group('TaxCalculator', () {
    test('Regla 1: aeronave local paga solo tasa × pasajeros', () {
      final TaxQuote quote = calculator.quote(
        registration: 'yv1234',
        typedModel: 'OTRO',
        passengers: 95,
        aircraft: localAircraft,
        taxRate: 15,
        dosaFee: 120,
      );
      expect(quote.isLocal, isTrue);
      expect(quote.registration, 'YV1234');
      expect(quote.aircraftModel, 'AC90');
      expect(quote.taxSubtotal, 1425);
      expect(quote.dosa, 0);
      expect(quote.total, 1425);
    });

    test('Regla 2: aeronave foránea paga DOSA + tasa × pasajeros', () {
      final TaxQuote quote = calculator.quote(
        registration: 'YV9999',
        typedModel: 'B737',
        passengers: 95,
        aircraft: null,
        taxRate: 15,
        dosaFee: 120,
      );
      expect(quote.isLocal, isFalse);
      expect(quote.aircraftModel, 'B737');
      expect(quote.taxSubtotal, 1425);
      expect(quote.dosa, 120);
      expect(quote.total, 1545);
    });

    test('rechaza cantidades de pasajeros inválidas', () {
      expect(
        () => calculator.quote(
          registration: 'YV1',
          typedModel: 'X',
          passengers: 0,
          aircraft: null,
          taxRate: 15,
          dosaFee: 120,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Formatters', () {
    test('número de factura con relleno de ceros', () {
      expect(Formatters.invoiceNumber(1), 'FACT-000001');
      expect(Formatters.invoiceNumber(123456), 'FACT-123456');
    });

    test('montos con separador de miles', () {
      expect(Formatters.money(1425), '€1,425');
      expect(Formatters.money(1545.5), '€1,545.5');
    });
  });

  group('buildInvoiceText', () {
    final Invoice invoice = Invoice(
      number: 'FACT-000001',
      createdAt: DateTime(2026, 7, 18, 14, 35),
      airportCode: 'SVMI',
      airportName: 'Maiquetía',
      registration: 'YV1234',
      aircraftModel: 'AC90',
      operatorName: 'Conviasa',
      passengers: 95,
      taxRate: 15,
      taxSubtotal: 1425,
      dosa: 120,
      total: 1545,
      paymentMethod: Invoice.methodCard,
      filePath: '',
      createdBy: 'kiosco',
    );

    test('contiene todos los datos de la factura', () {
      final String text = buildInvoiceText(invoice, AppStrings.es);
      expect(text, contains('SKYTAX'));
      expect(text, contains('FACT-000001'));
      expect(text, contains('18/07/2026'));
      expect(text, contains('14:35'));
      expect(text, contains('SVMI - Maiquetía'));
      // El operador no debe aparecer en la factura.
      expect(text, isNot(contains('Conviasa')));
      expect(text, contains('YV1234'));
      expect(text, contains('95 x €15'));
      expect(text, contains('€1,425'));
      expect(text, contains('€120'));
      expect(text, contains('€1,545'));
      expect(text, contains('TOTAL PAGADO'));
      expect(text, contains('Tarjeta'));
      expect(text, contains('Gracias por utilizar SkyTax'));
    });

    test('omite la DOSA para aeronaves locales', () {
      final Invoice local = Invoice(
        number: 'FACT-000002',
        createdAt: DateTime(2026, 7, 18, 15, 0),
        airportCode: 'SVMI',
        airportName: 'Maiquetía',
        registration: 'YV1234',
        aircraftModel: 'AC90',
        operatorName: 'Conviasa',
        passengers: 10,
        taxRate: 15,
        taxSubtotal: 150,
        dosa: 0,
        total: 150,
        paymentMethod: Invoice.methodMobile,
        filePath: '',
        createdBy: 'kiosco',
      );
      final String text = buildInvoiceText(local, AppStrings.es);
      expect(text, isNot(contains('DOSA')));
      expect(text, contains('Pago Móvil'));
    });
  });

  group('KioskActionBar', () {
    Widget harness(double width) => MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: KioskActionBar(
                  secondaryLabel: 'Ver factura',
                  secondaryIcon: Icons.receipt_long_rounded,
                  onSecondary: () {},
                  primaryLabel: 'Verificando pago...',
                  primaryIcon: Icons.check_rounded,
                  onPrimary: () {},
                ),
              ),
            ),
          ),
        );

    for (final double width in [320.0, 480.0, 800.0, 1280.0]) {
      testWidgets('sin desbordes ni texto partido a $width px', (tester) async {
        await tester.pumpWidget(harness(width));
        expect(tester.takeException(), isNull);

        // Ambas etiquetas presentes y limitadas a una sola línea.
        for (final String label in ['Ver factura', 'Verificando pago...']) {
          expect(find.text(label), findsOneWidget);
          final Text widget = tester.widget<Text>(find.text(label));
          expect(widget.maxLines, 1);
          expect(widget.softWrap, isFalse);
        }
      });
    }
  });
}

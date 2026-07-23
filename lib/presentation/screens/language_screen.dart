import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../state/app_controller.dart';
import '../widgets/kiosk_widgets.dart';
import 'menu_screen.dart';

/// Pantalla inicial: selección de idioma (Español / English).
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  void _select(BuildContext context, String code) {
    context.read<AppController>().setLanguage(code);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return KioskScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SkyTaxLogo(size: 280),
          const SizedBox(height: 40),
          Text(
            controller.strings.welcomeTouch,
            style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          const Text(
            'Seleccione el idioma · Select your language',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool wide = constraints.maxWidth > 560;
              final List<Widget> cards = [
                BigChoiceCard(
                  image: const _FlagBadge(painter: _VenezuelaFlagPainter()),
                  label: 'Español',
                  sublabel: 'Continuar en español',
                  onTap: () => _select(context, 'es'),
                ),
                BigChoiceCard(
                  image: const _FlagBadge(painter: _UkFlagPainter()),
                  label: 'English',
                  sublabel: 'Continue in English',
                  onTap: () => _select(context, 'en'),
                ),
              ];
              if (wide) {
                return Row(
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 24),
                    Expanded(child: cards[1]),
                  ],
                );
              }
              return Column(
                children: [cards[0], const SizedBox(height: 20), cards[1]],
              );
            },
          ),
          const SizedBox(height: 48),
          Text(
            controller.config.airportDisplay,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bandera dibujada localmente (sin assets externos), con bordes
/// redondeados y sombra suave para integrarse a las tarjetas.
class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.painter});

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: const Size(126, 84),
          painter: painter,
        ),
      ),
    );
  }
}

/// Bandera de Venezuela: tricolor con el arco de ocho estrellas.
class _VenezuelaFlagPainter extends CustomPainter {
  const _VenezuelaFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint paint = Paint();

    paint.color = const Color(0xFFFFCC00);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h / 3), paint);
    paint.color = const Color(0xFF00247D);
    canvas.drawRect(Rect.fromLTWH(0, h / 3, w, h / 3), paint);
    paint.color = const Color(0xFFCF142B);
    canvas.drawRect(Rect.fromLTWH(0, 2 * h / 3, w, h / 3), paint);

    // Arco de 8 estrellas dentro de la franja azul.
    final Paint star = Paint()..color = Colors.white;
    final Offset arcCenter = Offset(w / 2, h * 0.72);
    final double arcRadius = h * 0.27;
    for (int i = 0; i < 8; i++) {
      // Ángulos de 160° a 20° repartidos uniformemente.
      final double angle = math.pi * (160 - i * 20) / 180;
      final Offset center = arcCenter +
          Offset(math.cos(angle), -math.sin(angle)) * arcRadius;
      canvas.drawPath(_starPath(center, h * 0.045), star);
    }
  }

  Path _starPath(Offset center, double radius) {
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      final double outer = -math.pi / 2 + i * 2 * math.pi / 5;
      final double inner = outer + math.pi / 5;
      final Offset po =
          center + Offset(math.cos(outer), math.sin(outer)) * radius;
      final Offset pi =
          center + Offset(math.cos(inner), math.sin(inner)) * (radius * 0.45);
      if (i == 0) {
        path.moveTo(po.dx, po.dy);
      } else {
        path.lineTo(po.dx, po.dy);
      }
      path.lineTo(pi.dx, pi.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bandera del Reino Unido (Union Jack simplificada).
class _UkFlagPainter extends CustomPainter {
  const _UkFlagPainter();

  static const Color _blue = Color(0xFF012169);
  static const Color _red = Color(0xFFC8102E);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = _blue);

    // Aspas de San Andrés y San Patricio.
    final Paint whiteDiag = Paint()
      ..color = Colors.white
      ..strokeWidth = h * 0.24
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(w, h), whiteDiag);
    canvas.drawLine(Offset(w, 0), Offset(0, h), whiteDiag);

    final Paint redDiag = Paint()
      ..color = _red
      ..strokeWidth = h * 0.09
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(w, h), redDiag);
    canvas.drawLine(Offset(w, 0), Offset(0, h), redDiag);

    // Cruz de San Jorge con fimbriación blanca.
    final Paint white = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(w / 2 - h * 0.17, 0, h * 0.34, h), white);
    canvas.drawRect(Rect.fromLTWH(0, h / 2 - h * 0.17, w, h * 0.34), white);

    final Paint red = Paint()..color = _red;
    canvas.drawRect(Rect.fromLTWH(w / 2 - h * 0.10, 0, h * 0.20, h), red);
    canvas.drawRect(Rect.fromLTWH(0, h / 2 - h * 0.10, w, h * 0.20), red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

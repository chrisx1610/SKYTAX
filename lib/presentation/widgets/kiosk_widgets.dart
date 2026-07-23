import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Estructura base de las pantallas del kiosco: barra superior opcional y
/// contenido centrado con ancho máximo, apto para tablets y monitores.
///
/// El fondo lleva un lavado de marca muy sutil (gradiente + destello superior)
/// para dar profundidad sin restar legibilidad al contenido.
class KioskScaffold extends StatelessWidget {
  const KioskScaffold({
    super.key,
    this.title,
    this.actions,
    this.maxWidth = 860,
    this.scrollable = true,
    this.decorated = true,
    required this.child,
  });

  final String? title;
  final List<Widget>? actions;
  final double maxWidth;
  final bool scrollable;

  /// Aplica el lavado de marca de fondo. Se puede desactivar para pantallas
  /// que ya definen su propio fondo.
  final bool decorated;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: child,
      ),
    );

    final Widget body = SafeArea(
      child: scrollable
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: content),
              ),
            )
          : Center(child: content),
    );

    final Widget scaffold = Scaffold(
      backgroundColor: decorated ? Colors.transparent : null,
      appBar: (title != null || actions != null)
          ? AppBar(title: title == null ? null : Text(title!), actions: actions)
          : null,
      body: body,
    );

    // El lavado de marca envuelve todo el Scaffold (incluida la zona del
    // AppBar transparente); de lo contrario esa franja se vería negra.
    return decorated ? KioskBackground(child: scaffold) : scaffold;
  }
}

/// Lavado de fondo de marca: gradiente claro con un destello azul superior.
class KioskBackground extends StatelessWidget {
  const KioskBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7FAFE), Color(0xFFEFF3FA)],
        ),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -1.15),
            radius: 1.1,
            colors: [Color(0x142563EB), Color(0x002563EB)],
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Escala levemente el contenido al presionar, para dar respuesta táctil.
class _PressScale extends StatefulWidget {
  const _PressScale({required this.onTap, required this.builder});

  final VoidCallback? onTap;
  final Widget Function(bool pressed) builder;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (widget.onTap == null || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: (_pressed && !reduceMotion) ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.builder(_pressed),
      ),
    );
  }
}

/// Botón principal de gran tamaño para uso táctil.
///
/// El botón primario usa el gradiente de marca; la variante [tonal] usa el
/// contenedor secundario del tema.
class BigActionButton extends StatelessWidget {
  const BigActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tonal = false,
    this.height = 72,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool tonal;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool enabled = onPressed != null;

    final Widget text = Text(
      label,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );

    if (tonal) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: FilledButton.icon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.secondaryContainer,
            foregroundColor: scheme.onSecondaryContainer,
          ),
          icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 28),
          label: text,
        ),
      );
    }

    final List<Widget> rowChildren = [
      if (icon != null) ...[Icon(icon, size: 28), const SizedBox(width: 12)],
      Flexible(child: text),
    ];

    return _PressScale(
      onTap: onPressed,
      builder: (pressed) => Container(
        width: double.infinity,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: enabled ? AppTheme.brandGradient : null,
          color: enabled ? null : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled && !pressed
              ? [
                  BoxShadow(
                    color: AppTheme.brand.withValues(alpha: 0.32),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: enabled ? Colors.white : scheme.onSurfaceVariant,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              color: enabled ? Colors.white : scheme.onSurfaceVariant,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: rowChildren),
          ),
        ),
      ),
    );
  }
}

/// Barra de acciones con botón secundario (cancelar/atrás) y principal.
///
/// Se adapta al ancho disponible: en pantallas anchas coloca los botones lado
/// a lado; en pantallas angostas (teléfonos) los apila a todo el ancho. En
/// ambos casos el texto nunca se parte en dos líneas.
class KioskActionBar extends StatelessWidget {
  const KioskActionBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,
    this.stackBreakpoint = 480,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? secondaryIcon;

  /// Ancho por debajo del cual los botones se apilan verticalmente.
  final double stackBreakpoint;

  static const EdgeInsets _pad =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  Widget _text(String value) => Text(
        value,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      );

  Widget _primary({required double height}) => SizedBox(
        height: height,
        child: BigActionButton(
          label: primaryLabel,
          icon: primaryIcon,
          onPressed: onPrimary,
          height: height,
        ),
      );

  Widget _secondary({required double height}) {
    final ButtonStyle style = OutlinedButton.styleFrom(padding: _pad);
    final Widget child = secondaryIcon == null
        ? OutlinedButton(
            style: style,
            onPressed: onSecondary,
            child: _text(secondaryLabel!))
        : OutlinedButton.icon(
            style: style,
            onPressed: onSecondary,
            icon: Icon(secondaryIcon, size: 24),
            label: _text(secondaryLabel!),
          );
    return SizedBox(height: height, child: child);
  }

  @override
  Widget build(BuildContext context) {
    if (secondaryLabel == null) {
      return SizedBox(
        width: double.infinity,
        child: _primary(height: 72),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < stackBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _primary(height: 72),
              const SizedBox(height: 12),
              _secondary(height: 64),
            ],
          );
        }
        return Row(
          children: [
            Expanded(flex: 2, child: _secondary(height: 72)),
            const SizedBox(width: 20),
            Expanded(flex: 3, child: _primary(height: 72)),
          ],
        );
      },
    );
  }
}

/// Tarjeta de selección grande (idiomas, métodos de pago).
class BigChoiceCard extends StatelessWidget {
  const BigChoiceCard({
    super.key,
    this.icon,
    this.image,
    required this.label,
    this.sublabel,
    required this.onTap,
  }) : assert(icon != null || image != null, 'Se requiere icon o image');

  final IconData? icon;

  /// Ilustración personalizada (p. ej. una bandera). Cuando se indica,
  /// sustituye al contenedor con ícono.
  final Widget? image;
  final String label;
  final String? sublabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return _PressScale(
      onTap: onTap,
      builder: (pressed) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: pressed ? AppTheme.brand : scheme.outlineVariant,
            width: pressed ? 2 : 1,
          ),
          boxShadow: AppTheme.softShadow(opacity: pressed ? 0.05 : 0.09),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image ??
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.brandGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.brand.withValues(alpha: 0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 52, color: Colors.white),
                ),
            const SizedBox(height: 20),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            if (sublabel != null) ...[
              const SizedBox(height: 6),
              Text(
                sublabel!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Fila etiqueta/valor usada en resúmenes y confirmaciones.
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: emphasized ? 22 : 18,
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
                color: emphasized ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: emphasized ? 28 : 18,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
              color: emphasized ? AppTheme.gold : scheme.onSurface,
              letterSpacing: emphasized ? -0.5 : 0,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta de estado compacta (aeronave local / foránea, etc.).
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: foreground,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logotipo de la aplicación.
///
/// Muestra la imagen de marca `assets/images/skytax_logo.png`. Si el archivo
/// aún no está disponible, dibuja un respaldo con el emblema y el nombre para
/// que la interfaz nunca quede vacía.
class SkyTaxLogo extends StatelessWidget {
  const SkyTaxLogo({super.key, this.size = 220});

  /// Ancho máximo del logotipo.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppTheme.softShadow(opacity: 0.08),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/images/skytax_logo.png',
          width: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              _FallbackLogo(size: size),
        ),
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(size * 0.16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.brand.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(Icons.flight_takeoff_rounded,
              size: size * 0.28, color: Colors.white),
        ),
        SizedBox(height: size * 0.08),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Sky'),
              TextSpan(
                text: 'Tax',
                style: TextStyle(color: AppTheme.brand),
              ),
            ],
          ),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: AppTheme.ink,
          ),
        ),
      ],
    );
  }
}

/// Encabezado de sección del panel administrativo: título + acción opcional.
///
/// En pantallas anchas el título y el botón comparten una fila; en pantallas
/// angostas el botón baja a una segunda línea, de modo que el título nunca
/// se parte letra por letra.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        ?action,
      ],
    );
  }
}

/// Visor de texto monoespaciado para mostrar el contenido de una factura.
class InvoiceTextViewer extends StatelessWidget {
  const InvoiceTextViewer({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F2)),
      ),
      child: SingleChildScrollView(
        child: Text(
          content,
          style: const TextStyle(
            fontFamily: 'Consolas',
            fontFamilyFallback: ['Courier New', 'monospace'],
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

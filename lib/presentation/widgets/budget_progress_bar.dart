import 'package:flutter/material.dart';

import '../../core/theme/numo_palette.dart';

/// Barra de progreso fina. En tinta mientras todo va bien; pasa a rojo
/// cuando se supera el 80 % (cerca del límite o excedido). Anima el llenado.
class BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double limit;
  final double height;

  /// Color fijo (ignora la regla del 80 %), p. ej. para metas.
  final Color? color;

  /// Fondo de la barra; por defecto el del tema.
  final Color? trackColor;

  const BudgetProgressBar({
    super.key,
    required this.spent,
    required this.limit,
    this.height = 6,
    this.color,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final raw = limit <= 0 ? 0.0 : spent / limit;
    final ratio = raw.clamp(0.0, 1.0);
    final barColor = color ?? (raw > 0.8 ? p.expense : p.ink);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Stack(
        children: [
          Container(height: height, color: trackColor ?? p.track),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, _) => FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

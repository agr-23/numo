import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Barra de progreso de presupuesto. El color se calcula automáticamente
/// según el porcentaje gastado. Anima el llenado al aparecer.
class BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double limit;
  final double height;

  const BudgetProgressBar({
    super.key,
    required this.spent,
    required this.limit,
    this.height = 8,
  });

  Color get _color {
    final ratio = limit <= 0 ? 0.0 : spent / limit;
    if (ratio > 0.8) return AppColors.expense;
    if (ratio > 0.5) return AppColors.warning;
    return AppColors.income;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = (limit <= 0 ? 0.0 : spent / limit).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Stack(
        children: [
          Container(
            height: height,
            color: Theme.of(context).dividerColor,
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, _) => FractionallySizedBox(
              widthFactor: value,
              child: Container(height: height, color: _color),
            ),
          ),
        ],
      ),
    );
  }
}

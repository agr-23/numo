import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';

/// Círculo de color con un icono — usado para categorías, cuentas y metas.
class CategoryIcon extends StatelessWidget {
  final String iconName;
  final String colorHex;
  final double size;

  const CategoryIcon({
    super.key,
    required this.iconName,
    required this.colorHex,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.fromHex(colorHex);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        AppIcons.resolve(iconName),
        color: color,
        size: size * 0.5,
      ),
    );
  }
}

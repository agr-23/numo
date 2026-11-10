import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/numo_palette.dart';

/// Círculo con un ícono, para categorías, cuentas y metas.
///
/// El diseño Nítido es monocromo: círculo gris suave con el ícono en tinta.
/// Con [colored] usa el color propio del elemento (útil donde el color
/// distingue, como al administrar categorías).
class CategoryIcon extends StatelessWidget {
  final String iconName;
  final String? colorHex;
  final double size;
  final bool colored;

  const CategoryIcon({
    super.key,
    required this.iconName,
    this.colorHex,
    this.size = 36,
    this.colored = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final tint = colored && colorHex != null
        ? AppColors.fromHex(colorHex!)
        : null;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tint?.withValues(alpha: 0.15) ?? p.surfaceSubtle,
        shape: BoxShape.circle,
      ),
      child: Icon(
        AppIcons.resolve(iconName),
        color: tint ?? p.ink,
        size: size * 0.5,
      ),
    );
  }
}

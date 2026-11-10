import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_colors.dart';

/// Selector de color entre la paleta predefinida (12 colores).
class ColorPickerRow extends StatelessWidget {
  final String selectedHex;
  final ValueChanged<String> onSelected;

  const ColorPickerRow({
    super.key,
    required this.selectedHex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final color in AppColors.palette)
          GestureDetector(
            onTap: () => onSelected(AppColors.toHex(color)),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.toHex(color) == selectedHex
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: AppColors.toHex(color) == selectedHex
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
      ],
    );
  }
}

/// Selector de icono entre un set sugerido.
class IconPickerGrid extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onSelected;
  final List<String> icons;

  const IconPickerGrid({
    super.key,
    required this.selectedIcon,
    required this.onSelected,
    this.icons = AppIcons.pickerIcons,
  });

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.accent;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final name in icons)
          GestureDetector(
            onTap: () => onSelected(name),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: name == selectedIcon
                    ? accent.withValues(alpha: 0.18)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: name == selectedIcon
                      ? accent
                      : Theme.of(context).dividerColor,
                  width: name == selectedIcon ? 2 : 1,
                ),
              ),
              child: Icon(AppIcons.resolve(name),
                  color: name == selectedIcon ? accent : null),
            ),
          ),
      ],
    );
  }
}

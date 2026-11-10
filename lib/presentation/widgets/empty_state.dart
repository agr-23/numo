import 'package:flutter/material.dart';

import '../../core/constants/dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/numo_palette.dart';

/// Estado vacío: ícono, mensaje y una acción opcional.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.sectionGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration:
                  BoxDecoration(color: p.surfaceSubtle, shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: p.ink),
            ),
            const SizedBox(height: Dimens.cardPadding),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: p.inkMuted),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/numo_palette.dart';

/// Teclado de PIN de 4 dígitos con indicadores y biometría opcional.
/// [onCompleted] devuelve true si el PIN es válido; si devuelve false,
/// se limpia con feedback de error.
class PinPad extends StatefulWidget {
  final String title;
  final Future<bool> Function(String pin) onCompleted;
  final bool showBiometric;
  final VoidCallback? onBiometric;

  const PinPad({
    super.key,
    required this.title,
    required this.onCompleted,
    this.showBiometric = false,
    this.onBiometric,
  });

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _pin = '';
  bool _error = false;

  Future<void> _onDigit(String d) async {
    if (_pin.length >= 4) return;
    setState(() {
      _error = false;
      _pin += d;
    });
    unawaited(HapticFeedback.selectionClick());
    if (_pin.length == 4) {
      final ok = await widget.onCompleted(_pin);
      if (!ok && mounted) {
        unawaited(HapticFeedback.heavyImpact());
        setState(() {
          _error = true;
          _pin = '';
        });
      } else if (mounted) {
        setState(() => _pin = '');
      }
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 4; i++)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _pin.length
                      ? (_error ? context.palette.expense : context.palette.ink)
                      : Colors.transparent,
                  border: Border.all(
                    color: _error
                        ? context.palette.expense
                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
        if (_error)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              context.l10n.wrongPin,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.palette.expense,
              ),
            ),
          ),
        const SizedBox(height: 32),
        _keypad(),
      ],
    );
  }

  Widget _keypad() {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'bio',
      '0',
      'del',
    ];
    return SizedBox(
      width: 300,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.4,
        children: keys.map(_key).toList(),
      ),
    );
  }

  Widget _key(String label) {
    if (label == 'bio') {
      if (!widget.showBiometric) return const SizedBox.shrink();
      return IconButton(
        icon: const Icon(Icons.fingerprint, size: 30),
        onPressed: widget.onBiometric,
      );
    }
    if (label == 'del') {
      return IconButton(
        icon: const Icon(Icons.backspace_outlined),
        onPressed: _onBackspace,
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () => _onDigit(label),
      child: Center(child: Text(label, style: AppTextStyles.keypadDigit)),
    );
  }
}

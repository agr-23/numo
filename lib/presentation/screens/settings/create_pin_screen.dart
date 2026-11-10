import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../widgets/pin_pad.dart';

/// Flujo de creación de PIN: ingresar y confirmar. Al completar, hace
/// pop devolviendo el PIN de 4 dígitos (sin hashear).
class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String? _first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.ink,
      appBar: AppBar(
        backgroundColor: context.palette.ink,
        foregroundColor: context.palette.onInk,
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: context.palette.onInk,
              displayColor: context.palette.onInk,
            ),
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(onSurface: context.palette.onInk),
          ),
          child: Center(
            child: PinPad(
              key: ValueKey(_first == null ? 'enter' : 'confirm'),
              title: _first == null
                  ? context.l10n.createPin
                  : context.l10n.confirmPin,
              onCompleted: (pin) async {
                if (_first == null) {
                  setState(() => _first = pin);
                  return true;
                }
                if (_first == pin) {
                  context.pop(pin);
                  return true;
                }
                setState(() => _first = null);
                return false;
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
            colorScheme:
                Theme.of(context).colorScheme.copyWith(onSurface: Colors.white),
          ),
          child: Center(
            child: PinPad(
              key: ValueKey(_first == null ? 'enter' : 'confirm'),
              title: _first == null
                  ? 'Crea un PIN de 4 dígitos'
                  : 'Confirma tu PIN',
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

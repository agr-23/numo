import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/pin_hasher.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/pin_pad.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _decided = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final settings = ref.read(settingsProvider);
    if (!settings.isOnboardingDone) {
      if (mounted) context.go('/onboarding');
      return;
    }
    if (!settings.pinEnabled) {
      if (mounted) context.go('/home/dashboard');
      return;
    }
    setState(() => _decided = true);
    if (settings.biometricEnabled) {
      unawaited(_tryBiometric());
    }
  }

  Future<void> _tryBiometric() async {
    try {
      final reason = context.l10n.unlockReason;
      final auth = LocalAuthentication();
      final canCheck = await auth.isDeviceSupported();
      if (!canCheck) return;
      final ok = await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (ok && mounted) context.go('/home/dashboard');
    } catch (_) {
      // Si la biometría falla, el usuario usa el PIN.
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (!_decided) {
      return Scaffold(
        backgroundColor: context.palette.ink,
        body: Center(
          child: Text(
            'Numo',
            style: TextStyle(
              color: context.palette.onInk,
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.palette.ink,
      body: SafeArea(
        child: Theme(
          // Texto claro sobre el fondo oscuro del lock.
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
              title: context.l10n.enterPin,
              showBiometric: settings.biometricEnabled,
              onBiometric: _tryBiometric,
              onCompleted: (pin) async {
                final ok = PinHasher.verify(pin, settings.pinHash);
                if (ok && mounted) {
                  context.go('/home/dashboard');
                }
                return ok;
              },
            ),
          ),
        ),
      ),
    );
  }
}

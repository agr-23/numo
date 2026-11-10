import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/theme/app_colors.dart';
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
      _tryBiometric();
    }
  }

  Future<void> _tryBiometric() async {
    try {
      final auth = LocalAuthentication();
      final canCheck = await auth.isDeviceSupported();
      if (!canCheck) return;
      final ok = await auth.authenticate(
        localizedReason: 'Desbloquea Numo',
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
      return const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Text('Numo',
              style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 40,
                  fontWeight: FontWeight.w700)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Theme(
          // Texto claro sobre el fondo oscuro del lock.
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
              title: 'Ingresa tu PIN',
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/capture_service.dart';

final captureServiceProvider = Provider<CaptureService>(
  (_) => CaptureService(),
);

/// Si el usuario dio el acceso a notificaciones en los ajustes de Android.
final captureAccessProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(captureServiceProvider).accessGranted(),
);

final selectedAppsProvider = FutureProvider.autoDispose<Set<String>>(
  (ref) => ref.watch(captureServiceProvider).selectedApps(),
);

final installedAppsProvider = FutureProvider.autoDispose<List<InstalledApp>>(
  (ref) => ref.watch(captureServiceProvider).installedApps(),
);

final capturedNoticesProvider =
    FutureProvider.autoDispose<List<CapturedNotice>>(
      (ref) => ref.watch(captureServiceProvider).notices(),
    );

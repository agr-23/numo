import 'package:flutter/services.dart';

import '../../core/utils/sensitive_filter.dart';

/// Aviso capturado de una app elegida por el usuario.
class CapturedNotice {
  const CapturedNotice({
    required this.id,
    required this.packageName,
    required this.appLabel,
    required this.title,
    required this.text,
    required this.postedAt,
  });

  factory CapturedNotice.fromMap(Map<Object?, Object?> m) => CapturedNotice(
    id: m['id']! as String,
    packageName: m['pkg']! as String,
    appLabel: m['app'] as String? ?? '',
    title: m['title'] as String? ?? '',
    text: m['text'] as String? ?? '',
    postedAt: DateTime.fromMillisecondsSinceEpoch(m['postedAt']! as int),
  );

  final String id;
  final String packageName;
  final String appLabel;
  final String title;
  final String text;
  final DateTime postedAt;

  /// Título y cuerpo, como se copian para compartir.
  String get fullText =>
      [title, text].where((s) => s.trim().isNotEmpty).join('\n');
}

/// App con ícono en el lanzador.
class InstalledApp {
  const InstalledApp({required this.packageName, required this.label});

  factory InstalledApp.fromMap(Map<Object?, Object?> m) => InstalledApp(
    packageName: m['package']! as String,
    label: m['label'] as String? ?? '',
  );

  final String packageName;
  final String label;
}

/// Puente con el servicio nativo de captura
/// (android/.../capture/CaptureChannel.kt).
///
/// Fuera de Android (pruebas, escritorio) responde valores vacíos.
class CaptureService {
  CaptureService([MethodChannel? channel])
    : _channel = channel ?? const MethodChannel('com.numo.numo/capture');

  final MethodChannel _channel;

  Future<T?> _invoke<T>(String method, [Object? args]) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null;
    }
  }

  Future<bool> accessGranted() async =>
      await _invoke<bool>('accessGranted') ?? false;

  Future<void> openAccessSettings() => _invoke<void>('openAccessSettings');

  Future<List<InstalledApp>> installedApps() async {
    final raw = await _invoke<List<Object?>>('installedApps') ?? const [];
    return [
      for (final m in raw.cast<Map<Object?, Object?>>())
        InstalledApp.fromMap(m),
    ];
  }

  Future<Set<String>> selectedApps() async {
    final raw = await _invoke<List<Object?>>('selectedApps') ?? const [];
    return raw.cast<String>().toSet();
  }

  Future<void> setSelectedApps(Set<String> packages) =>
      _invoke<void>('setSelectedApps', packages.toList());

  /// Avisos guardados, del más reciente al más antiguo. Si alguno resulta
  /// sensible, se borra en vez de devolverlo.
  Future<List<CapturedNotice>> notices() async {
    final raw = await _invoke<List<Object?>>('notices') ?? const [];
    final result = <CapturedNotice>[];
    for (final m in raw.cast<Map<Object?, Object?>>()) {
      final notice = CapturedNotice.fromMap(m);
      if (SensitiveFilter.isSensitive(notice.fullText)) {
        await delete(notice.id);
      } else {
        result.add(notice);
      }
    }
    result.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return result;
  }

  Future<void> delete(String id) => _invoke<void>('delete', id);

  Future<void> clear() => _invoke<void>('clear');
}

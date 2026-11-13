import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo/data/services/capture_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.numo.numo/capture');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('sin servicio nativo responde valores vacíos', () async {
    final service = CaptureService();
    expect(await service.accessGranted(), isFalse);
    expect(await service.notices(), isEmpty);
    expect(await service.selectedApps(), isEmpty);
  });

  test('lee avisos, borra los sensibles y ordena del más reciente', () async {
    final deleted = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'notices':
          return [
            {
              'id': 'a',
              'pkg': 'com.ejemplo.banco',
              'app': 'Banco Ejemplo',
              'title': 'Compra aprobada',
              'text': 'Compraste \$10.000 en TIENDA',
              'postedAt': 1000,
            },
            {
              'id': 'b',
              'pkg': 'com.ejemplo.banco',
              'app': 'Banco Ejemplo',
              'title': '',
              'text': 'Tu código es 123456',
              'postedAt': 3000,
            },
            {
              'id': 'c',
              'pkg': 'com.ejemplo.banco',
              'app': 'Banco Ejemplo',
              'title': 'Transferencia',
              'text': 'Recibiste \$5.000',
              'postedAt': 2000,
            },
          ];
        case 'delete':
          deleted.add(call.arguments as String);
          return null;
      }
      return null;
    });

    final notices = await CaptureService().notices();
    expect(notices.map((n) => n.id), ['c', 'a']);
    expect(deleted, ['b']);
    expect(
      notices.last.fullText,
      'Compra aprobada\nCompraste \$10.000 en TIENDA',
    );
  });
}

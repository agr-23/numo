import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/utils/csv_writer.dart';

String _body(String csv) => csv.substring(CsvWriter.bom.length);

void main() {
  group('CsvWriter', () {
    test('filas simples con BOM y CRLF', () {
      final csv = CsvWriter.encode([
        ['Fecha', 'Monto'],
        ['2026-11-13', 45000],
      ]);
      expect(csv.startsWith(CsvWriter.bom), isTrue);
      expect(_body(csv), 'Fecha,Monto\r\n2026-11-13,45000\r\n');
    });

    test('comillas, comas y saltos de línea', () {
      expect(
        _body(
          CsvWriter.encode([
            ['Pan, leche', 'Dijo "hola"', 'línea 1\nlínea 2', null],
          ]),
        ),
        '"Pan, leche","Dijo ""hola""","línea 1\nlínea 2",\r\n',
      );
    });

    test('neutraliza fórmulas en textos pero no en números', () {
      expect(
        _body(
          CsvWriter.encode([
            ['=HYPERLINK("x")', '+57', '@SUM(A1)', -12.5, 'Éxito'],
          ]),
        ),
        '"\'=HYPERLINK(""x"")",\'+57,\'@SUM(A1),-12.5,Éxito\r\n',
      );
    });
  });
}

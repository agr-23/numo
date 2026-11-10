import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/transaction.dart';
import '../services/isar_service.dart';

/// Exporta todas las transacciones a CSV y abre el menú de compartir.
class ExportService {
  static Future<void> exportTransactions() async {
    final Isar isar = IsarService.instance.isar;
    final txs = await isar.transactions.where().sortByDate().findAll();
    for (final t in txs) {
      t.category.loadSync();
      t.account.loadSync();
      t.toAccount.loadSync();
    }

    final dateFmt = DateFormat('yyyy-MM-dd');
    final rows = <List<dynamic>>[
      ['Fecha', 'Título', 'Tipo', 'Categoría', 'Cuenta', 'Cuenta destino', 'Monto', 'Nota'],
      for (final t in txs)
        [
          dateFmt.format(t.date),
          t.title,
          _typeLabel(t.type),
          t.category.value?.name ?? '',
          t.account.value?.name ?? '',
          t.toAccount.value?.name ?? '',
          t.amount,
          t.note ?? '',
        ],
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${dir.path}/numo_export_$stamp.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Exportación de Numo',
      text: 'Mis movimientos de Numo',
    );
  }

  static String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return 'Gasto';
      case TransactionType.income:
        return 'Ingreso';
      case TransactionType.transfer:
        return 'Transferencia';
    }
  }
}

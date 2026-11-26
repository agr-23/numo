import 'dart:io';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/csv_writer.dart';
import '../models/transaction.dart';
import '../services/isar_service.dart';

/// Exporta todas las transacciones a CSV y abre el menú de compartir.
class ExportService {
  static Future<void> exportTransactions(AppLocalizations l10n) async {
    final isar = IsarService.instance.isar;
    final txs = await isar.transactions.where().sortByDate().findAll();
    for (final t in txs) {
      t.category.loadSync();
      t.account.loadSync();
      t.toAccount.loadSync();
    }

    final dateFmt = DateFormat('yyyy-MM-dd');
    final rows = <List<Object?>>[
      [
        l10n.date,
        l10n.title,
        l10n.type,
        l10n.category,
        l10n.account,
        l10n.exportDestAccount,
        l10n.amount,
        l10n.note,
      ],
      for (final t in txs)
        [
          dateFmt.format(t.date),
          t.title,
          _typeLabel(t.type, l10n),
          categoryLabel(t.category.value, l10n),
          t.account.value?.name ?? '',
          t.toAccount.value?.name ?? '',
          t.amount,
          t.note ?? '',
        ],
    ];

    final csv = CsvWriter.encode(rows);
    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${dir.path}/numo_export_$stamp.csv');
    await file.writeAsString(csv);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/csv')],
        subject: l10n.exportSubject,
        text: l10n.exportText,
      ),
    );
  }

  static String _typeLabel(TransactionType type, AppLocalizations l10n) {
    switch (type) {
      case TransactionType.expense:
        return l10n.expense;
      case TransactionType.income:
        return l10n.income;
      case TransactionType.transfer:
        return l10n.transfer;
    }
  }
}

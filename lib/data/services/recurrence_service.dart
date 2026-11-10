import 'package:isar/isar.dart';

import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Genera las ocurrencias pendientes de las transacciones recurrentes.
/// Se ejecuta al iniciar la app, tras abrir Isar.
class RecurrenceService {
  static Future<void> processRecurring(Isar isar) async {
    final repo = TransactionRepository();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final templates = await isar.transactions
        .filter()
        .isRecurringEqualTo(true)
        .findAll();

    for (final template in templates) {
      template.account.loadSync();
      template.category.loadSync();
      final accountId = template.account.value?.id;
      if (accountId == null) continue;
      final categoryId = template.category.value?.id;

      var next = template.nextRecurrenceDate;
      final freq = template.recurrenceFrequency;
      if (next == null || freq == null) continue;

      var generated = false;
      // Genera todas las ocurrencias vencidas (incluye períodos perdidos).
      while (!next!.isAfter(today)) {
        if (template.recurrenceEndDate != null &&
            next.isAfter(template.recurrenceEndDate!)) {
          break;
        }
        final copy = Transaction()
          ..title = template.title
          ..amount = template.amount
          ..type = template.type
          ..date = next
          ..note = template.note
          ..isRecurring = false
          ..parentRecurringId = template.id
          ..pocketId = template.pocketId;

        await repo.add(copy, accountId: accountId, categoryId: categoryId);

        next = _nextDate(next, freq);
        generated = true;
      }

      if (generated) {
        template.nextRecurrenceDate = next;
        await isar.writeTxn(() async {
          await isar.transactions.put(template);
        });
      }
    }
  }

  static DateTime _nextDate(DateTime from, String frequency) {
    switch (frequency) {
      case 'daily':
        return from.add(const Duration(days: 1));
      case 'weekly':
        return from.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(from.year, from.month + 1, from.day);
      case 'yearly':
        return DateTime(from.year + 1, from.month, from.day);
      default:
        return from;
    }
  }
}

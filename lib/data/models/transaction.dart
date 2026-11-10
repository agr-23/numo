import 'package:isar/isar.dart';

import 'account.dart';
import 'category.dart';

part 'transaction.g.dart';

enum TransactionType { expense, income, transfer }

@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late String title;
  late double amount;

  @Enumerated(EnumType.name)
  late TransactionType type;

  @Index()
  late DateTime date;

  String? note;

  @Index()
  late bool isRecurring;

  String? recurrenceFrequency; // 'daily', 'weekly', 'monthly', 'yearly'
  DateTime? recurrenceEndDate;

  @Index()
  DateTime? nextRecurrenceDate;

  int? parentRecurringId; // ID de la transacción recurrente original

  // Relaciones
  final category = IsarLink<Category>();
  final account = IsarLink<Account>();
  final toAccount = IsarLink<Account>(); // Solo para transferencias
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/repositories/pocket_repository.dart';
import 'data/services/isar_service.dart';
import 'data/services/recurrence_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final service = await IsarService.init();
  await RecurrenceService.processRecurring(service.isar);
  await PocketRepository.rollAll(service.isar, DateTime.now());
  runApp(const ProviderScope(child: NumoApp()));
}

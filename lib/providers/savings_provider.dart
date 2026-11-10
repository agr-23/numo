import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/pocket_math.dart';
import '../data/models/pocket.dart';
import '../data/models/savings_group.dart';
import '../data/repositories/pocket_repository.dart';

final pocketRepositoryProvider = Provider<PocketRepository>(
  (ref) => PocketRepository(),
);

final savingsGroupsProvider = StreamProvider<List<SavingsGroup>>((ref) {
  return ref.watch(pocketRepositoryProvider).watchGroups();
});

final pocketsProvider = StreamProvider<List<Pocket>>((ref) {
  return ref.watch(pocketRepositoryProvider).watchPockets();
});

/// Un grupo con sus bolsillos y totales.
class GroupView {
  final SavingsGroup group;
  final List<Pocket> pockets;
  const GroupView(this.group, this.pockets);

  double get saved => pockets.fold(0, (s, p) => s + p.savedAmount);
  double get target => pockets.fold(0, (s, p) => s + p.targetAmount);
  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);

  List<Pocket> ofKind(PocketKind kind) =>
      pockets.where((p) => p.kind == kind).toList();

  /// Bolsillo con fecha (anual o meta) que vence primero y aún le falta.
  Pocket? get mostUrgent {
    final dated =
        pockets
            .where((p) => p.dueDate != null && PocketMath.remaining(p) > 0)
            .toList()
          ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return dated.isEmpty ? null : dated.first;
  }

  bool get allDone =>
      pockets.isNotEmpty && pockets.every((p) => PocketMath.remaining(p) <= 0);
}

final groupViewsProvider = Provider<List<GroupView>>((ref) {
  final groups = ref.watch(savingsGroupsProvider).valueOrNull ?? const [];
  final pockets = ref.watch(pocketsProvider).valueOrNull ?? const [];
  return [
    for (final g in groups)
      GroupView(g, pockets.where((p) => p.groupId == g.id).toList()),
  ];
});

final groupViewProvider = Provider.family<GroupView?, int>((ref, id) {
  for (final v in ref.watch(groupViewsProvider)) {
    if (v.group.id == id) return v;
  }
  return null;
});

/// Dinero apartado en bolsillos, por cuenta.
final setAsideByAccountProvider = Provider<Map<int, double>>((ref) {
  final pockets = ref.watch(pocketsProvider).valueOrNull ?? const [];
  return PocketMath.setAsideByAccount(pockets);
});

/// Totales de todos los ahorros.
class SavingsOverview {
  final int groupCount;
  final double saved;
  final double target;

  /// Bolsillos sin cuenta (metas antiguas): dinero registrado aparte.
  final double savedOutsideAccounts;
  const SavingsOverview(
    this.groupCount,
    this.saved,
    this.target,
    this.savedOutsideAccounts,
  );
  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);
}

final savingsOverviewProvider = Provider<SavingsOverview>((ref) {
  final views = ref.watch(groupViewsProvider);
  final pockets = ref.watch(pocketsProvider).valueOrNull ?? const [];
  var saved = 0.0, target = 0.0, outside = 0.0;
  for (final p in pockets) {
    if (p.savedAmount > 0) saved += p.savedAmount;
    target += p.targetAmount;
    if (p.accountId == null && p.savedAmount > 0) outside += p.savedAmount;
  }
  return SavingsOverview(views.length, saved, target, outside);
});

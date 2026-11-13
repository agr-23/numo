import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/services/capture_service.dart';
import '../../../providers/capture_provider.dart';
import '../../widgets/empty_state.dart';

/// Avisos capturados, para copiarlos y conocer el formato de cada banco.
class CapturedNoticesScreen extends ConsumerWidget {
  const CapturedNoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(capturedNoticesProvider);
    final notices = async.valueOrNull ?? const <CapturedNotice>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.amNotices),
        actions: [
          if (notices.isNotEmpty)
            TextButton(
              onPressed: () => _clearAll(context, ref),
              child: Text(l10n.amClearAll),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(capturedNoticesProvider.future),
        child: async.isLoading && notices.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : notices.isEmpty
            ? ListView(
                children: [
                  const SizedBox(height: 80),
                  EmptyState(
                    icon: Icons.inbox_outlined,
                    message: l10n.amNoticesEmpty,
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.screenPaddingH,
                  4,
                  Dimens.screenPaddingH,
                  24,
                ),
                children: [
                  _Warning(l10n.amNoticesShareWarning),
                  const SizedBox(height: 12),
                  for (final n in notices) _NoticeCard(notice: n),
                ],
              ),
      ),
    );
  }

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.amClearAll),
        content: Text(l10n.amClearAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.palette.expense,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(captureServiceProvider).clear();
    ref.invalidate(capturedNoticesProvider);
  }
}

class _Warning extends StatelessWidget {
  const _Warning(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.privacy_tip_outlined, size: 20, color: p.warning),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _NoticeCard extends ConsumerWidget {
  const _NoticeCard({required this.notice});

  final CapturedNotice notice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = context.palette;
    final theme = Theme.of(context);
    final when =
        '${DateFormatter.groupHeader(notice.postedAt, l10n)} · '
        '${DateFormat.Hm().format(notice.postedAt)}';

    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.itemGap),
      padding: const EdgeInsets.fromLTRB(Dimens.cardPadding, 12, 4, 8),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${notice.appLabel} · $when',
            style: theme.textTheme.bodySmall?.copyWith(color: p.inkMuted),
          ),
          const SizedBox(height: 6),
          if (notice.title.isNotEmpty)
            Text(
              notice.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (notice.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SelectableText(notice.text),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.copy, size: 18),
                label: Text(l10n.amCopy),
                onPressed: () {
                  unawaited(
                    Clipboard.setData(ClipboardData(text: notice.fullText)),
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.amCopied)));
                },
              ),
              IconButton(
                tooltip: l10n.delete,
                icon: Icon(Icons.delete_outline, color: p.inkMuted),
                onPressed: () async {
                  await ref.read(captureServiceProvider).delete(notice.id);
                  ref.invalidate(capturedNoticesProvider);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

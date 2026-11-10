import 'package:flutter/material.dart';

import '../constants/dimens.dart';
import 'app_text_styles.dart';
import 'numo_palette.dart';

/// Construye los [ThemeData] claro y oscuro del diseño Nítido a partir de
/// [NumoPalette].
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light, NumoPalette.light);
  static ThemeData get dark => _build(Brightness.dark, NumoPalette.dark);

  static ThemeData _build(Brightness brightness, NumoPalette p) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.ink,
      onPrimary: p.onInk,
      secondary: p.link,
      onSecondary: p.onInk,
      secondaryContainer: p.surfaceMuted,
      onSecondaryContainer: p.ink,
      error: p.expense,
      onError: p.onInk,
      surface: p.surface,
      onSurface: p.ink,
      onSurfaceVariant: p.inkMuted,
      surfaceContainerHighest: p.surfaceMuted,
      surfaceContainerHigh: p.surfaceMuted,
      surfaceContainer: p.surfaceSubtle,
      surfaceContainerLow: p.surface,
      outline: p.borderStrong,
      outlineVariant: p.border,
      inverseSurface: p.ink,
      onInverseSurface: p.onInk,
    );

    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.chipRadius),
    );
    OutlineInputBorder inputBorder(Color c, [double w = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTextStyles.family,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      textTheme: AppTextStyles.themeFor(p.ink, p.inkMuted),
      dividerColor: p.border,
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title.copyWith(color: p.ink),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          side: BorderSide(color: p.border),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.inkMuted,
        titleTextStyle: AppTextStyles.body.copyWith(color: p.ink),
        subtitleTextStyle: AppTextStyles.caption.copyWith(color: p.inkMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.ink,
          foregroundColor: p.onInk,
          minimumSize: const Size(64, Dimens.buttonHeight),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.cardRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.ink,
          side: BorderSide(color: p.borderStrong),
          minimumSize: const Size(64, 44),
          textStyle: AppTextStyles.labelFrom(14),
          shape: controlShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.link,
          textStyle: AppTextStyles.labelFrom(14),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: p.ink),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.ink,
        foregroundColor: p.onInk,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        color: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.ink : p.surface,
        ),
        // Chip sin seleccionar / seleccionado (Flutter usa
        // secondaryLabelStyle para el texto del chip seleccionado).
        labelStyle: AppTextStyles.labelFrom(13).copyWith(color: p.ink),
        secondaryLabelStyle: AppTextStyles.labelFrom(13).copyWith(color: p.onInk),
        side: WidgetStateBorderSide.resolveWith(
          (s) => BorderSide(
              color: s.contains(WidgetState.selected) ? p.ink : p.borderStrong),
        ),
        showCheckmark: false,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? p.ink : p.surfaceMuted,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? p.onInk : p.inkMuted,
          ),
          side: WidgetStatePropertyAll(BorderSide(color: p.surfaceMuted)),
          textStyle: WidgetStatePropertyAll(AppTextStyles.labelFrom(13)),
          shape: WidgetStatePropertyAll(controlShape),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.onInk : p.inkHint,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.ink : p.surfaceMuted,
        ),
        trackOutlineColor: WidgetStatePropertyAll(p.borderStrong),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.ink,
        linearTrackColor: p.track,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        hintStyle: AppTextStyles.body.copyWith(color: p.inkHint),
        labelStyle: AppTextStyles.body.copyWith(color: p.inkMuted),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((s) {
          final color = s.contains(WidgetState.error)
              ? p.expense
              : s.contains(WidgetState.focused)
                  ? p.ink
                  : p.inkMuted;
          return AppTextStyles.body.copyWith(color: color);
        }),
        helperStyle: AppTextStyles.caption.copyWith(color: p.inkMuted),
        prefixStyle: AppTextStyles.body.copyWith(color: p.inkMuted),
        suffixStyle: AppTextStyles.body.copyWith(color: p.inkMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.cardPadding,
          vertical: 16,
        ),
        border: inputBorder(p.border),
        enabledBorder: inputBorder(p.border),
        focusedBorder: inputBorder(p.ink, 1.5),
        errorBorder: inputBorder(p.expense),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.ink,
        selectionHandleColor: p.ink,
        selectionColor: p.link.withValues(alpha: 0.25),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.ink,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: p.onInk),
        actionTextColor: p.snackAction,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Dimens.sheetRadius)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.sheetRadius),
        ),
        titleTextStyle: AppTextStyles.headline.copyWith(color: p.ink),
        contentTextStyle: AppTextStyles.body.copyWith(color: p.inkMuted),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: p.surface,
        headerForegroundColor: p.ink,
      ),
    );
  }
}

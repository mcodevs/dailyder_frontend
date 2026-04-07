import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TodaySubmissionTheme extends StatelessWidget {
  const TodaySubmissionTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildTodaySubmissionTheme(Theme.of(context)),
      child: child,
    );
  }
}

ThemeData buildTodaySubmissionTheme(ThemeData base) {
  const background = Color(0xFF0B1016);
  const surface = Color(0xFF151C27);
  const surfaceAlt = Color(0xFF101722);
  const border = Color(0xFF273042);
  const borderStrong = Color(0xFF314050);
  const textPrimary = Color(0xFFF2F6FB);
  const textSecondary = Color(0xFF94A3B8);

  final textTheme = base.textTheme
      .apply(bodyColor: textPrimary, displayColor: textPrimary)
      .copyWith(
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: textPrimary,
          height: 1.35,
        ),
        bodySmall: base.textTheme.bodySmall?.copyWith(
          color: textSecondary,
          height: 1.35,
        ),
      );

  final colorScheme = base.colorScheme.copyWith(
    brightness: Brightness.dark,
    primary: AppColors.accent,
    onPrimary: Colors.white,
    secondary: const Color(0xFF78A9FF),
    surface: surface,
    onSurface: textPrimary,
    outline: border,
    error: AppColors.danger,
  );

  return base.copyWith(
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    textTheme: textTheme,
    iconTheme: const IconThemeData(color: textPrimary),
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: border),
      ),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceAlt,
      hintStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
      labelStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF384452),
        disabledForegroundColor: const Color(0xFF9AA7B8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.accent),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: surfaceAlt,
      selectedColor: AppColors.accentSoft,
      labelStyle: textTheme.bodySmall,
      side: const BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
  );
}

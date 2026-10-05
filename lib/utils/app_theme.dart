import 'package:flutter/material.dart';

abstract final class AppColors {
  static const purple = Color(0xFF7338EA);
  static const yellow = Color(0xFFFFCF32);
  static const ink = Color(0xFF211638);
  static const navy = Color(0xFF121529);
}

abstract final class AppTheme {
  static ThemeData build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.purple, brightness: brightness).copyWith(
      primary: dark ? const Color(0xFFBFA1FF) : AppColors.purple,
      onPrimary: dark ? AppColors.ink : Colors.white,
      secondary: AppColors.yellow, onSecondary: AppColors.ink,
      surface: dark ? const Color(0xFF1C2038) : Colors.white,
      onSurface: dark ? const Color(0xFFF5F0FF) : AppColors.ink,
      onSurfaceVariant: dark ? const Color(0xFFC4C1D5) : const Color(0xFF686174),
      outlineVariant: dark ? const Color(0xFF3F435E) : const Color(0xFFE5DFF0),
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme, brightness: brightness, fontFamily: 'Nunito');
    return base.copyWith(
      scaffoldBackgroundColor: dark ? AppColors.navy : const Color(0xFFFAF8FF),
      textTheme: base.textTheme.copyWith(
        displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.w900, height: 1.05, color: scheme.onSurface),
        headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: 1.18, color: scheme.onSurface),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.25, color: scheme.onSurface),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.3, color: scheme.onSurface),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.4, color: scheme.onSurface),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: scheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: scheme.onSurfaceVariant),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: scheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: scheme.surface, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: scheme.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: scheme.outlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: scheme.primary, width: 2)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary, linearTrackColor: scheme.primary.withValues(alpha: .12), borderRadius: BorderRadius.circular(12), linearMinHeight: 8),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(minimumSize: const Size(48, 48), foregroundColor: scheme.primary)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(minimumSize: const Size(48, 48), textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800))),
    );
  }
}

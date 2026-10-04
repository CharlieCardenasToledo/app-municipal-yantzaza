import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Custom theme tokens not covered by standard Material 3 ThemeData.
/// Includes glassmorphism, tonal shadows, and brand gradients.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color? glassBackground;
  final double? glassBlur;
  final LinearGradient? primaryGradient;
  final BoxShadow? tonalShadow;
  final Color? errorContainerLight;
  final Color? onErrorContainerLight;

  const AppThemeExtension({
    this.glassBackground,
    this.glassBlur,
    this.primaryGradient,
    this.tonalShadow,
    this.errorContainerLight,
    this.onErrorContainerLight,
  });

  static final _light = AppThemeExtension(
    glassBackground: Color(0xCCFFFFFF),
    glassBlur: 20.0,
    primaryGradient: LinearGradient(
      colors: [AppColors.primary, AppColors.primaryContainer],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    tonalShadow: BoxShadow(
      color: Color(0x0A191C1D),
      blurRadius: 32,
      spreadRadius: -4,
    ),
    errorContainerLight: AppColors.errorContainer.withValues(alpha: 0.4),
    onErrorContainerLight: AppColors.onErrorContainer,
  );

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? glassBackground,
    double? glassBlur,
    LinearGradient? primaryGradient,
    BoxShadow? tonalShadow,
    Color? errorContainerLight,
    Color? onErrorContainerLight,
  }) {
    return AppThemeExtension(
      glassBackground: glassBackground ?? this.glassBackground,
      glassBlur: glassBlur ?? this.glassBlur,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      tonalShadow: tonalShadow ?? this.tonalShadow,
      errorContainerLight: errorContainerLight ?? this.errorContainerLight,
      onErrorContainerLight: onErrorContainerLight ?? this.onErrorContainerLight,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t),
      glassBlur: ui.lerpDouble(glassBlur, other.glassBlur, t),
      primaryGradient: primaryGradient,
      tonalShadow: BoxShadow.lerp(tonalShadow, other.tonalShadow, t),
      errorContainerLight: Color.lerp(
        errorContainerLight, other.errorContainerLight, t,
      ),
      onErrorContainerLight: Color.lerp(
        onErrorContainerLight, other.onErrorContainerLight, t,
      ),
    );
  }
}

/// Complete Material 3 light theme for Mi Yantzaza.
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    inverseSurface: AppColors.inverseSurface,
    inversePrimary: AppColors.inversePrimary,
    surfaceTint: AppColors.surfaceTint,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,

    // ─── Typography ────────────────────────────────────────────
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLg,
      displayMedium: AppTypography.displayMd,
      displaySmall: AppTypography.displaySm,
      headlineLarge: AppTypography.headlineLg,
      headlineMedium: AppTypography.headlineMd,
      headlineSmall: AppTypography.headlineSm,
      titleLarge: AppTypography.titleLg,
      titleMedium: AppTypography.titleMd,
      titleSmall: AppTypography.titleSm,
      bodyLarge: AppTypography.bodyLg,
      bodyMedium: AppTypography.bodyMd,
      bodySmall: AppTypography.bodySm,
      labelLarge: AppTypography.labelLg,
      labelMedium: AppTypography.labelMd,
      labelSmall: AppTypography.labelSm,
    ),

    // ─── Extensions ────────────────────────────────────────────
    extensions: <ThemeExtension<dynamic>>[
      AppThemeExtension._light,
    ],

    // ─── Components ────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.onSurface,
    ),

    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.surfaceContainerLowest,
      indicatorColor: AppColors.primaryFixed,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSm.copyWith(color: AppColors.primary);
        }
        return AppTypography.labelSm.copyWith(color: AppColors.outline);
      }),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.outline),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTypography.buttonText,
        elevation: 0,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    dividerTheme: const DividerThemeData(
      space: 0,
      thickness: 0,
      color: Colors.transparent,
    ),
  );
}

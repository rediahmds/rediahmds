import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Material 3 Expressive theme configuration.
///
/// All design tokens (color, typography, shape, component themes) are
/// defined here so that the rest of the codebase only refers to
/// `Theme.of(context)` — zero ad-hoc styling.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Shape tokens  (M3 Expressive — generous rounding)
  // ---------------------------------------------------------------------------
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 28.0;
  static const double radiusExtraLarge = 32.0;

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Builds the full [TextTheme] from Google Fonts Inter.
  /// No custom font sizes — strictly uses M3 type scale defaults.
  static TextTheme _buildTextTheme(Brightness brightness) {
    final base = GoogleFonts.interTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );

    // Emphasize Display & Headline weights for hero sections.
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  /// Stadium-shaped buttons (fully-rounded pill shape — M3 Expressive).
  static final _stadiumShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(100),
  );

  // ---------------------------------------------------------------------------
  // Component themes
  // ---------------------------------------------------------------------------

  static CardThemeData _cardTheme() {
    return CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: _stadiumShape,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: _stadiumShape,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: _stadiumShape,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme cs) {
    return InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  static ChipThemeData _chipTheme(ColorScheme cs) {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
      ),
      side: BorderSide.none,
      backgroundColor: cs.secondaryContainer,
      labelStyle: TextStyle(
        color: cs.onSecondaryContainer,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static NavigationRailThemeData _navigationRailTheme(ColorScheme cs) {
    return NavigationRailThemeData(
      backgroundColor: cs.surfaceContainerLow,
      indicatorColor: cs.secondaryContainer,
      selectedIconTheme: IconThemeData(color: cs.onSecondaryContainer),
      unselectedIconTheme: IconThemeData(color: cs.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(
        color: cs.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: cs.onSurfaceVariant,
        fontSize: 12,
      ),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme cs) {
    return NavigationBarThemeData(
      backgroundColor: cs.surfaceContainer,
      indicatorColor: cs.secondaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: cs.onSecondaryContainer);
        }
        return IconThemeData(color: cs.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }
        return TextStyle(color: cs.onSurfaceVariant, fontSize: 12);
      }),
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme cs) {
    return DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      backgroundColor: cs.surfaceContainerHigh,
    );
  }

  static DropdownMenuThemeData _dropdownMenuTheme(ColorScheme cs) {
    return DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Public API — build full ThemeData
  // ---------------------------------------------------------------------------

  /// Build a complete [ThemeData] for the given [seedColor] and [brightness].
  static ThemeData buildTheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      // Use high contrast variant for M3 Expressive vibrance
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    final textTheme = _buildTextTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // Component themes
      cardTheme: _cardTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      navigationRailTheme: _navigationRailTheme(colorScheme),
      navigationBarTheme: _navigationBarTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      dropdownMenuTheme: _dropdownMenuTheme(colorScheme),

      // App bar — transparent to let surface color through
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Visual density for desktop
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

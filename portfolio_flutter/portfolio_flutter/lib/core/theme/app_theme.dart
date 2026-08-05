import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolio_colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Define our custom colors based on the design system
  static const PortfolioColors _darkColors = PortfolioColors(
    background: Color(0xFF050505),
    surface: Color(0xFF0A0A0A),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFFA1A1AA),
    accent: Color(0xFF4F8CFF),
    accentGlow: Color(0xFF6E9FFF),
    border: Color(0xFF141414),
  );

  /// The primary dark theme for the portfolio.
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.chakraPetchTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _darkColors.background,
      
      // Inject our custom semantic colors
      extensions: <ThemeExtension<dynamic>>[
        _darkColors,
      ],
      
      // Configure default Material fallback colors mapping to our system
      colorScheme: ColorScheme.dark(
        background: _darkColors.background,
        surface: _darkColors.surface,
        primary: _darkColors.accent,
        onPrimary: _darkColors.primaryText,
        secondary: _darkColors.secondaryText,
      ),

      // Global Typography Configuration
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: _darkColors.primaryText,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          color: _darkColors.primaryText,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
          height: 1.2,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: _darkColors.primaryText,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: _darkColors.secondaryText,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          height: 1.65,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: _darkColors.secondaryText,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          height: 1.6,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: _darkColors.primaryText,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Extension helper for quick access in UI widgets
extension ThemeContextExtension on BuildContext {
  PortfolioColors get colors => Theme.of(this).extension<PortfolioColors>()!;
  TextTheme get typography => Theme.of(this).textTheme;
}

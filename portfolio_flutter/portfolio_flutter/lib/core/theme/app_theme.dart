import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolio_colors.dart';

class AppTheme {
  
  AppTheme._();

  
  static const PortfolioColors _darkColors = PortfolioColors(
    background: Color(0xFF050505),
    surface: Color(0xFF0A0A0A),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFFA1A1AA),
    accent: Color(0xFF4F8CFF),
    accentGlow: Color(0xFF6E9FFF),
    border: Color(0xFF141414),
  );

  
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.chakraPetchTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _darkColors.background,

      
      extensions: <ThemeExtension<dynamic>>[_darkColors],

      
      colorScheme: ColorScheme.dark(
        surface: _darkColors.surface,
        primary: _darkColors.accent,
        onPrimary: _darkColors.primaryText,
        secondary: _darkColors.secondaryText,
      ),

      
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


extension ThemeContextExtension on BuildContext {
  PortfolioColors get colors => Theme.of(this).extension<PortfolioColors>()!;
  TextTheme get typography => Theme.of(this).textTheme;
}

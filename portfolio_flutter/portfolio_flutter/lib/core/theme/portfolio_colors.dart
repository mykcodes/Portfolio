import 'package:flutter/material.dart';

/// Custom theme extension to handle our specific premium color palette.
/// This ensures type-safe access to our semantic colors without hacking Material's ColorScheme.
class PortfolioColors extends ThemeExtension<PortfolioColors> {
  final Color background;
  final Color surface;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color accentGlow;
  final Color border;

  const PortfolioColors({
    required this.background,
    required this.surface,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.accentGlow,
    required this.border,
  });

  @override
  ThemeExtension<PortfolioColors> copyWith({
    Color? background,
    Color? surface,
    Color? primaryText,
    Color? secondaryText,
    Color? accent,
    Color? accentGlow,
    Color? border,
  }) {
    return PortfolioColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      accent: accent ?? this.accent,
      accentGlow: accentGlow ?? this.accentGlow,
      border: border ?? this.border,
    );
  }

  @override
  ThemeExtension<PortfolioColors> lerp(
    covariant ThemeExtension<PortfolioColors>? other,
    double t,
  ) {
    if (other is! PortfolioColors) {
      return this;
    }
    return PortfolioColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

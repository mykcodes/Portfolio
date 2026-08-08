import 'package:flutter/material.dart';

class RenderConfig {
  final double particleDensity;
  final double blurRadiusMultiplier;
  final double glowIntensity;
  final bool enableContinuousAnimations;
  final bool enableMouseEffects;
  final bool enableParallax;

  const RenderConfig({
    required this.particleDensity,
    required this.blurRadiusMultiplier,
    required this.glowIntensity,
    required this.enableContinuousAnimations,
    required this.enableMouseEffects,
    required this.enableParallax,
  });

  static const desktop = RenderConfig(
    particleDensity: 1.0,
    blurRadiusMultiplier: 1.0,
    glowIntensity: 1.0,
    enableContinuousAnimations: true,
    enableMouseEffects: true,
    enableParallax: true,
  );

  static const mobile = RenderConfig(
    particleDensity: 0.2, // Drastically reduce particles
    blurRadiusMultiplier: 0.25, // Reduce blur expense
    glowIntensity: 0.3, // Reduce glow intensity
    enableContinuousAnimations: false, // Event-driven only
    enableMouseEffects: false, // Touch only
    enableParallax: false, // Remove parallax CPU overhead
  );
}

class MobileRenderEngine {
  static RenderConfig getConfig(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return screenWidth < 600 ? RenderConfig.mobile : RenderConfig.desktop;
  }
}

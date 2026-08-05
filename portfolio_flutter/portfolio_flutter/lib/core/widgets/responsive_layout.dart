import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';

/// A macro-level layout wrapper that seamlessly switches between UI components
/// based on the current screen width.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet; // Optional: If null, falls back to desktop layout
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    // Using sizeOf optimizes performance by only rebuilding when size changes,
    // ignoring other MediaQuery data like viewInsets (keyboard).
    final double screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth >= AppBreakpoints.tablet) {
      return desktop;
    } else if (screenWidth >= AppBreakpoints.mobile) {
      // If a specific tablet layout isn't provided, default to the desktop experience
      return tablet ?? desktop;
    } else {
      return mobile;
    }
  }
}

/// A highly efficient extension on BuildContext for micro-level responsiveness.
/// Use this for adapting padding, font sizes, or flex values directly inside a widget.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppBreakpoints.mobile;
  
  bool get isTablet => 
      screenWidth >= AppBreakpoints.mobile && 
      screenWidth < AppBreakpoints.tablet;
      
  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;
}

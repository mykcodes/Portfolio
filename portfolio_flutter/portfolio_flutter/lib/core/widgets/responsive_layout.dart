import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';



class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth >= AppBreakpoints.largeDesktop) {
      return largeDesktop ?? desktop;
    } else if (screenWidth >= AppBreakpoints.desktop) {
      return desktop;
    } else if (screenWidth >= AppBreakpoints.tablet) {
      return tablet ?? desktop;
    } else {
      return mobile;
    }
  }
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppBreakpoints.tablet;

  bool get isTablet =>
      screenWidth >= AppBreakpoints.tablet &&
      screenWidth < AppBreakpoints.desktop;

  bool get isDesktop => screenWidth >= AppBreakpoints.desktop;

  bool get isLargeDesktop => screenWidth >= AppBreakpoints.largeDesktop;
}

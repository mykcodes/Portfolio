import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';



class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet; 
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    
    
    final double screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth >= AppBreakpoints.tablet) {
      return desktop;
    } else if (screenWidth >= AppBreakpoints.mobile) {
      
      return tablet ?? desktop;
    } else {
      return mobile;
    }
  }
}



extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppBreakpoints.mobile;

  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;

  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;
}

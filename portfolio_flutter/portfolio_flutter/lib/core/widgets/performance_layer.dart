import 'package:flutter/material.dart';

/// Wraps complex modules to prevent global layout thrashing.
class PerformanceLayer extends StatelessWidget {
  final Widget child;
  const PerformanceLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}

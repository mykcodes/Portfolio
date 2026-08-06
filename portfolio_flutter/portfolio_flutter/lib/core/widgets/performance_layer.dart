import 'package:flutter/material.dart';


class PerformanceLayer extends StatelessWidget {
  final Widget child;
  const PerformanceLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}

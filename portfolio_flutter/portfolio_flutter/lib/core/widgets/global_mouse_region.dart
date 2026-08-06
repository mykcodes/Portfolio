import 'package:flutter/material.dart';

import '../controllers/experience_controller.dart';

class GlobalMouseRegion extends StatelessWidget {
  final Widget child;
  const GlobalMouseRegion({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        
        ExperienceController.instance.updateCursorPosition(event.position);
      },
      child: child,
    );
  }
}

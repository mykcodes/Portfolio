import 'dart:ui';
import 'package:flutter/material.dart';

/// The glass surface container for the engineering console.
/// Dark minimal terminal with frosted glass, subtle reflections,
/// and professional border treatment.
class ConsoleSurface extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  const ConsoleSurface({
    super.key,
    required this.child,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xE8080808), // Near-opaque dark
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0x1AFFFFFF),
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 40,
                spreadRadius: -8,
                offset: Offset(0, 20),
              ),
              BoxShadow(
                color: Color(0x084F8CFF),
                blurRadius: 60,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title bar
              _ConsoleTitleBar(),
              // Divider
              Container(
                height: 1,
                color: const Color(0x14FFFFFF),
              ),
              // Content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsoleTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Window control dots
          _WindowDot(color: const Color(0xFFFF5F57)),
          const SizedBox(width: 8),
          _WindowDot(color: const Color(0xFFFEBC2E)),
          const SizedBox(width: 8),
          _WindowDot(color: const Color(0xFF28C840)),
          const SizedBox(width: 16),

          // Title
          const Expanded(
            child: Text(
              'myk-codes — engineering console',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11,
                color: Color(0x66FFFFFF),
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Subtle version indicator
          const Text(
            'v3.0',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 10,
              color: Color(0x33FFFFFF),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;
  const _WindowDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.8),
      ),
    );
  }
}

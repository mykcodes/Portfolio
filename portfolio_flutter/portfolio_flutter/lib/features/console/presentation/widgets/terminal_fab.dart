import 'dart:ui';
import 'package:flutter/material.dart';

class TerminalFab extends StatefulWidget {
  final VoidCallback onTap;

  const TerminalFab({super.key, required this.onTap});

  @override
  State<TerminalFab> createState() => _TerminalFabState();
}

class _TerminalFabState extends State<TerminalFab>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _breathingController,
          builder: (context, child) {
            final breathingScale = 1.0 + (_breathingController.value * 0.05);
            final scale = _isHovered ? 1.1 : breathingScale;

            return Transform.scale(
              scale: scale,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0x2A4F8CFF)
                          : const Color(0x1A4F8CFF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isHovered
                            ? const Color(0x664F8CFF)
                            : const Color(0x334F8CFF),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F8CFF).withValues(
                            alpha: _isHovered
                                ? 0.4
                                : 0.2 + (_breathingController.value * 0.1),
                          ),
                          blurRadius: _isHovered ? 30 : 20,
                          spreadRadius: _isHovered ? 4 : 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.terminal_rounded,
                        color: _isHovered
                            ? Colors.white
                            : const Color(0xCCFFFFFF),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

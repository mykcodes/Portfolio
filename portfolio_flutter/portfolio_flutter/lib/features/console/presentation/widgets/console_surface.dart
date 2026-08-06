import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/controllers/console_controller.dart';




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
            color: const Color(0xE8080808), 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1AFFFFFF), width: 1.0),
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
              
              _ConsoleTitleBar(),
              
              Container(height: 1, color: const Color(0x14FFFFFF)),
              
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
          
          _WindowDot(
            color: const Color(0xFFFF5F57),
            onTap: () => ConsoleController.instance.close(),
          ),
          const SizedBox(width: 8),
          _WindowDot(color: const Color(0xFFFEBC2E)),
          const SizedBox(width: 8),
          _WindowDot(color: const Color(0xFF28C840)),
          const SizedBox(width: 16),

          
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

class _WindowDot extends StatefulWidget {
  final Color color;
  final VoidCallback? onTap;

  const _WindowDot({required this.color, this.onTap});

  @override
  State<_WindowDot> createState() => _WindowDotState();
}

class _WindowDotState extends State<_WindowDot> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered && widget.onTap != null
                ? widget.color
                : widget.color.withValues(alpha: 0.8),
          ),
          child: _isHovered && widget.onTap != null
              ? const Icon(Icons.close, size: 8, color: Colors.black54)
              : null,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/terminal_command_model.dart';

class TerminalCommandRow extends StatefulWidget {
  final TerminalCommandModel command;
  final int delayMs;

  const TerminalCommandRow({
    super.key,
    required this.command,
    required this.delayMs,
  });

  @override
  State<TerminalCommandRow> createState() => _TerminalCommandRowState();
}

class _TerminalCommandRowState extends State<TerminalCommandRow> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isVisible = false;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0x0A4F8CFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? const Color(0x334F8CFF) : Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '> ',
              style: GoogleFonts.jetBrainsMono(
                textStyle: TextStyle(
                  color: _isHovered ? const Color(0xFF4F8CFF) : const Color(0x73FFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              widget.command.command,
              style: GoogleFonts.jetBrainsMono(
                textStyle: TextStyle(
                  color: _isHovered ? Colors.white : const Color(0x99FFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (_isHovered)
              AnimatedBuilder(
                animation: _cursorController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _cursorController.value,
                    child: Container(
                      width: 8,
                      height: 16,
                      color: const Color(0xFF4F8CFF),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
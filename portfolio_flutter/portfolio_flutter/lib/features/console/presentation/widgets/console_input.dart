import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The input line of the engineering console.
/// Features a blinking block cursor, prompt prefix, and monospace styling.
class ConsoleInput extends StatefulWidget {
  final String currentInput;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onHistoryUp;
  final VoidCallback onHistoryDown;
  final VoidCallback onTabComplete;
  final FocusNode focusNode;
  final TextEditingController textController;

  const ConsoleInput({
    super.key,
    required this.currentInput,
    required this.onChanged,
    required this.onSubmit,
    required this.onHistoryUp,
    required this.onHistoryDown,
    required this.onTabComplete,
    required this.focusNode,
    required this.textController,
  });

  @override
  State<ConsoleInput> createState() => _ConsoleInputState();
}

class _ConsoleInputState extends State<ConsoleInput> {
  bool _cursorVisible = true;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
  }

  void _startCursorBlink() async {
    while (!_disposed && mounted) {
      await Future.delayed(const Duration(milliseconds: 530));
      if (!_disposed && mounted) {
        setState(() => _cursorVisible = !_cursorVisible);
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x0DFFFFFF), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Prompt
          Text(
            '❯ ',
            style: GoogleFonts.jetBrainsMono(
              textStyle: const TextStyle(
                color: Color(0xFF4F8CFF),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Input field
          Expanded(
            child: KeyboardListener(
              focusNode: FocusNode(), // Placeholder — actual key handling in parent
              onKeyEvent: (event) {},
              child: TextField(
                controller: widget.textController,
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                onSubmitted: (_) => widget.onSubmit(),
                style: GoogleFonts.jetBrainsMono(
                  textStyle: const TextStyle(
                    color: Color(0xDDFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                cursorColor: const Color(0xFF4F8CFF),
                cursorWidth: 8.0,
                cursorHeight: 16.0,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: 'type a command...',
                  hintStyle: GoogleFonts.jetBrainsMono(
                    textStyle: const TextStyle(
                      color: Color(0x26FFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/console_controller.dart';

/// Renders console output with animated typing effect.
/// Each new entry animates character-by-character for authenticity.
/// Uses a ScrollController to auto-scroll to bottom on new content.
class ConsoleOutput extends StatefulWidget {
  final List<ConsoleEntry> entries;
  final ScrollController scrollController;

  const ConsoleOutput({
    super.key,
    required this.entries,
    required this.scrollController,
  });

  @override
  State<ConsoleOutput> createState() => _ConsoleOutputState();
}

class _ConsoleOutputState extends State<ConsoleOutput> {
  // Track which entries have finished their typing animation
  final Set<int> _fullyRendered = {};
  // Current entry being animated
  int _animatingIndex = -1;
  String _animatedText = '';
  bool _disposed = false;

  @override
  void didUpdateWidget(ConsoleOutput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If new entries were added, animate the latest one
    if (widget.entries.length > oldWidget.entries.length) {
      // Mark all previous entries as fully rendered
      for (int i = 0; i < oldWidget.entries.length; i++) {
        _fullyRendered.add(i);
      }
      // Start animating the newest entry
      _animateLatestEntry();
    }
  }

  Future<void> _animateLatestEntry() async {
    final index = widget.entries.length - 1;
    if (index < 0) return;

    final entry = widget.entries[index];
    _animatingIndex = index;
    _animatedText = '';

    // Commands echo instantly
    if (entry.type == EntryType.command) {
      _fullyRendered.add(index);
      _animatingIndex = -1;
      if (mounted) setState(() {});
      _scrollToBottom();
      return;
    }

    // Animate output character by character
    final fullText = entry.content;
    for (int i = 0; i <= fullText.length; i++) {
      if (_disposed || !mounted) return;
      // Skip animation if new entry came in while animating
      if (widget.entries.length - 1 != index) {
        _fullyRendered.add(index);
        break;
      }

      _animatedText = fullText.substring(0, i);
      setState(() {});
      _scrollToBottom();

      // Variable speed for authenticity
      if (fullText[i < fullText.length ? i : fullText.length - 1] == '\n') {
        await Future.delayed(const Duration(milliseconds: 8));
      } else {
        await Future.delayed(const Duration(milliseconds: 3));
      }
    }

    _fullyRendered.add(index);
    _animatingIndex = -1;
    if (mounted) setState(() {});
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        String displayText;

        if (_fullyRendered.contains(index)) {
          displayText = entry.content;
        } else if (_animatingIndex == index) {
          displayText = _animatedText;
        } else {
          displayText = entry.content;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SelectableText(
            displayText,
            style: GoogleFonts.jetBrainsMono(
              textStyle: TextStyle(
                color: _getColorForType(entry.type),
                fontSize: 12,
                fontWeight: entry.type == EntryType.command
                    ? FontWeight.w600
                    : FontWeight.w400,
                letterSpacing: 0.3,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorForType(EntryType type) {
    switch (type) {
      case EntryType.command:
        return const Color(0xBBFFFFFF);
      case EntryType.output:
        return const Color(0x99FFFFFF);
      case EntryType.system:
        return const Color(0xFF4F8CFF);
      case EntryType.error:
        return const Color(0xFFFF6B6B);
    }
  }
}

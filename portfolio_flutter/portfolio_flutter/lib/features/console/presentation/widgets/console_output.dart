import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/console_controller.dart';




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
  final Set<int> _fullyRendered = {};

  @override
  void didUpdateWidget(ConsoleOutput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entries.length > oldWidget.entries.length) {
      for (int i = 0; i < oldWidget.entries.length; i++) {
        _fullyRendered.add(i);
      }
      _scrollToBottom();
    }
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
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        final isCommand = entry.type == EntryType.command;
        final isFullyRendered = _fullyRendered.contains(index) || isCommand;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: isFullyRendered
              ? SelectableText(entry.content, style: _getStyle(entry.type))
              : TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: entry.content.length),
                  
                  duration: Duration(
                    milliseconds: (entry.content.length * 2).clamp(100, 800),
                  ),
                  curve: Curves.linear,
                  onEnd: () {
                    if (mounted) {
                      setState(() => _fullyRendered.add(index));
                    }
                  },
                  builder: (context, length, child) {
                    
                    if (length % 10 == 0) _scrollToBottom();

                    return SelectableText(
                      entry.content.substring(0, length),
                      style: _getStyle(entry.type),
                    );
                  },
                ),
        );
      },
    );
  }

  TextStyle _getStyle(EntryType type) {
    return GoogleFonts.jetBrainsMono(
      textStyle: TextStyle(
        color: _getColorForType(type),
        fontSize: 12,
        fontWeight: type == EntryType.command
            ? FontWeight.w600
            : FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.5,
      ),
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

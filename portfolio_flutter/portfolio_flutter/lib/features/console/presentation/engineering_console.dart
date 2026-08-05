import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/controllers/console_controller.dart';
import '../../../core/experience/sound_engine.dart';
import 'widgets/console_surface.dart';
import 'widgets/console_input.dart';
import 'widgets/console_output.dart';

/// The main interactive engineering console overlay.
/// Opens from bottom-right with smooth animation.
/// Handles keyboard shortcuts: Tab (autocomplete), ↑↓ (history), ` (toggle).
class EngineeringConsole extends StatefulWidget {
  const EngineeringConsole({super.key});

  @override
  State<EngineeringConsole> createState() => _EngineeringConsoleState();
}

class _EngineeringConsoleState extends State<EngineeringConsole>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final FocusNode _inputFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _outputScrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.3), // Slide from right + slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    ConsoleController.instance.addListener(_onConsoleStateChanged);
  }

  void _onConsoleStateChanged() {
    if (ConsoleController.instance.isOpen) {
      _slideController.forward();
      // Focus input after animation
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) _inputFocusNode.requestFocus();
      });
    } else {
      _slideController.reverse();
    }
    setState(() {});
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;

    // Tab autocomplete
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      ConsoleController.instance.autocomplete();
      _textController.text = ConsoleController.instance.currentInput;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
      return;
    }

    // History navigation
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      ConsoleController.instance.navigateHistory(true);
      _textController.text = ConsoleController.instance.currentInput;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      ConsoleController.instance.navigateHistory(false);
      _textController.text = ConsoleController.instance.currentInput;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
      return;
    }
  }

  void _onInputChanged(String value) {
    ConsoleController.instance.updateInput(value);
  }

  void _onSubmit() {
    SoundEngine.instance.playTerminalEnter();
    ConsoleController.instance.executeCommand();
    _textController.clear();
    _inputFocusNode.requestFocus();
  }

  @override
  void dispose() {
    ConsoleController.instance.removeListener(_onConsoleStateChanged);
    _slideController.dispose();
    _inputFocusNode.dispose();
    _textController.dispose();
    _outputScrollController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ConsoleController.instance.isOpen && !_slideController.isAnimating) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.sizeOf(context);
    // Console takes up right side of screen, max 560px wide, max 480px tall
    final consoleWidth = screenSize.width > 600 ? 560.0 : screenSize.width - 40;
    final consoleHeight = screenSize.height > 600 ? 480.0 : screenSize.height - 120;

    return Positioned(
      right: 20,
      bottom: 20,
      width: consoleWidth,
      height: consoleHeight,
      child: AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: child,
            ),
          );
        },
        child: KeyboardListener(
          focusNode: _keyboardFocusNode,
          onKeyEvent: _handleKeyEvent,
          child: ConsoleSurface(
            isVisible: ConsoleController.instance.isOpen,
            child: Column(
              children: [
                // Output area
                Expanded(
                  child: AnimatedBuilder(
                    animation: ConsoleController.instance,
                    builder: (context, _) {
                      return ConsoleOutput(
                        entries: ConsoleController.instance.outputBuffer,
                        scrollController: _outputScrollController,
                      );
                    },
                  ),
                ),
                // Input area
                AnimatedBuilder(
                  animation: ConsoleController.instance,
                  builder: (context, _) {
                    return ConsoleInput(
                      currentInput: ConsoleController.instance.currentInput,
                      onChanged: _onInputChanged,
                      onSubmit: _onSubmit,
                      onHistoryUp: () =>
                          ConsoleController.instance.navigateHistory(true),
                      onHistoryDown: () =>
                          ConsoleController.instance.navigateHistory(false),
                      onTabComplete: () =>
                          ConsoleController.instance.autocomplete(),
                      focusNode: _inputFocusNode,
                      textController: _textController,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/controllers/console_controller.dart';
import '../../../core/experience/sound_engine.dart';
import 'widgets/console_surface.dart';
import 'widgets/console_input.dart';
import 'widgets/console_output.dart';
import 'widgets/terminal_fab.dart';




class EngineeringConsole extends StatefulWidget {
  const EngineeringConsole({super.key});

  @override
  State<EngineeringConsole> createState() => _EngineeringConsoleState();
}

class _EngineeringConsoleState extends State<EngineeringConsole> {
  final FocusNode _inputFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _outputScrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ConsoleController.instance.addListener(_onConsoleStateChanged);
  }

  void _onConsoleStateChanged() {
    if (ConsoleController.instance.isOpen) {
      
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) _inputFocusNode.requestFocus();
      });
    }
    setState(() {});
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;

    
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      ConsoleController.instance.autocomplete();
      _textController.text = ConsoleController.instance.currentInput;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
      return;
    }

    
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
    _inputFocusNode.dispose();
    _textController.dispose();
    _outputScrollController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ConsoleController.instance.isOpen;
    final screenSize = MediaQuery.sizeOf(context);

    
    final consoleWidth = screenSize.width > 600 ? 560.0 : screenSize.width - 40;
    final consoleHeight = screenSize.height > 600
        ? 480.0
        : screenSize.height - 120;
    const collapsedSize = 64.0;

    return Positioned(
      right: 20,
      bottom: 20,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: isOpen ? consoleWidth : collapsedSize,
        height: isOpen ? consoleHeight : collapsedSize,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              curve: isOpen
                  ? Curves.easeOut
                  : const Interval(0.5, 1.0, curve: Curves.easeIn),
              opacity: isOpen ? 0.0 : 1.0,
              child: IgnorePointer(
                ignoring: isOpen,
                child: TerminalFab(
                  onTap: () {
                    SoundEngine.instance.playClick();
                    ConsoleController.instance.open();
                  },
                ),
              ),
            ),

            
            AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              curve: isOpen
                  ? const Interval(0.4, 1.0, curve: Curves.easeIn)
                  : Curves.easeOut,
              opacity: isOpen ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !isOpen,
                child: KeyboardListener(
                  focusNode: _keyboardFocusNode,
                  onKeyEvent: _handleKeyEvent,
                  child: ConsoleSurface(
                    isVisible: isOpen,
                    child: Column(
                      children: [
                        
                        Expanded(
                          child: AnimatedBuilder(
                            animation: ConsoleController.instance,
                            builder: (context, _) {
                              return ConsoleOutput(
                                entries:
                                    ConsoleController.instance.outputBuffer,
                                scrollController: _outputScrollController,
                              );
                            },
                          ),
                        ),
                        
                        AnimatedBuilder(
                          animation: ConsoleController.instance,
                          builder: (context, _) {
                            return ConsoleInput(
                              currentInput:
                                  ConsoleController.instance.currentInput,
                              onChanged: _onInputChanged,
                              onSubmit: _onSubmit,
                              onHistoryUp: () => ConsoleController.instance
                                  .navigateHistory(true),
                              onHistoryDown: () => ConsoleController.instance
                                  .navigateHistory(false),
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
            ),
          ],
        ),
      ),
    );
  }
}

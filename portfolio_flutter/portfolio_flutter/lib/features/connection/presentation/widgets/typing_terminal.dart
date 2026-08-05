import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/experience/sound_engine.dart';

class TypingTerminal extends StatefulWidget {
  const TypingTerminal({super.key});

  @override
  State<TypingTerminal> createState() => _TypingTerminalState();
}

class _TypingTerminalState extends State<TypingTerminal> {
  String _line1 = "";
  String _line2 = "";
  String _line3 = "";
  bool _showList = false;
  bool _hasTyped = false;
  bool _cursorVisible = true;

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
  }
  
  void _startCursorBlink() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) break;
      setState(() => _cursorVisible = !_cursorVisible);
    }
  }

  Future<void> _startBootSequence() async {
    if (_hasTyped) return;
    _hasTyped = true;

    const String target1 = "> connection_terminal.exe";
    const String target2 = "Checking availability...";
    const String target3 = "Connection established.";

    // Slight delay before terminal boots
    await Future.delayed(const Duration(milliseconds: 600));

    // Type Line 1
    for (int i = 0; i <= target1.length; i++) {
      if (!mounted) return;
      setState(() => _line1 = target1.substring(0, i));
      if (i > 0) SoundEngine.instance.playTerminalType();
      await Future.delayed(const Duration(milliseconds: 30));
    }
    
    SoundEngine.instance.playTerminalEnter();

    await Future.delayed(const Duration(milliseconds: 400));

    // Type Line 2
    for (int i = 0; i <= target2.length; i++) {
      if (!mounted) return;
      setState(() => _line2 = target2.substring(0, i));
      if (i > 0) SoundEngine.instance.playTerminalType();
      await Future.delayed(const Duration(milliseconds: 20));
    }

    await Future.delayed(const Duration(milliseconds: 600));

    // Snap Line 3
    if (!mounted) return;
    setState(() => _line3 = target3);
    SoundEngine.instance.playSuccess();
    
    await Future.delayed(const Duration(milliseconds: 300));

    // Reveal List
    if (!mounted) return;
    setState(() => _showList = true);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('terminal-visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.4 && !_hasTyped) {
          _startBootSequence();
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x054F8CFF),
              blurRadius: 30,
              offset: Offset(0, 16),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0x14FFFFFF),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTerminalLine(_line1, const Color(0xFF4F8CFF), isActive: _line2.isEmpty && !_showList),
                  if (_line2.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildTerminalLine(_line2, const Color(0x8CFFFFFF), isActive: _line3.isEmpty && !_showList),
                  ],
                  if (_line3.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildTerminalLine(_line3, const Color(0xFF10B981), isActive: !_showList), // Success Green
                  ],
                  if (_showList) ...[
                    const SizedBox(height: 24),
                    _buildTerminalLine("Available for:", const Color(0xCCFFFFFF), isActive: false),
                    const SizedBox(height: 12),
                    _buildListItem("Engineering Opportunities"),
                    _buildListItem("Research Projects"),
                    _buildListItem("Startups"),
                    _buildListItem("Collaboration", isActive: true), // Final cursor here
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTerminalLine(String text, Color color, {bool isActive = false}) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.jetBrainsMono(
          textStyle: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        children: [
          TextSpan(text: text),
          if (isActive)
            TextSpan(
              text: _cursorVisible ? " █" : "  ",
              style: const TextStyle(color: Color(0xFF4F8CFF)),
            ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "• ",
            style: TextStyle(color: Color(0x59FFFFFF), fontSize: 14),
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.jetBrainsMono(
                textStyle: const TextStyle(
                  color: Color(0x99FFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              children: [
                TextSpan(text: text),
                if (isActive)
                  TextSpan(
                    text: _cursorVisible ? " █" : "  ",
                    style: const TextStyle(color: Color(0xFF4F8CFF)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

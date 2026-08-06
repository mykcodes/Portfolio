import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/motion_system.dart';
import '../../../../content/portfolio_data.dart';


const String _githubSvg =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>''';

const String _linkedInSvg =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/></svg>''';

class ContactArea extends StatelessWidget {
  const ContactArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactReveal(
          delayMs: 4600,
          child: Text(
            FooterData.contactHeading,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            _ContactReveal(
              delayMs: 4700,
              child: ContactButton(
                label: 'GitHub',
                helperText: 'Explore my repositories',
                iconSvg: _githubSvg,
                url: TerminalData.connectionChannels
                    .firstWhere((e) => e.label == 'GitHub')
                    .url,
              ),
            ),
            _ContactReveal(
              delayMs: 4800,
              child: ContactButton(
                label: 'LinkedIn',
                helperText: "Let's connect professionally",
                iconSvg: _linkedInSvg,
                url: TerminalData.connectionChannels
                    .firstWhere((e) => e.label == 'LinkedIn')
                    .url,
              ),
            ),
            _ContactReveal(
              delayMs: 4900,
              child: ContactButton(
                label: 'Email',
                helperText: 'Start a conversation',
                iconData: Icons.mail_outline,
                url: TerminalData.connectionChannels
                    .firstWhere((e) => e.label == 'Email')
                    .url,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactReveal extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const _ContactReveal({required this.child, required this.delayMs});

  @override
  State<_ContactReveal> createState() => _ContactRevealState();
}

class _ContactRevealState extends State<_ContactReveal> {
  bool _start = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) setState(() => _start = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _start ? 1.0 : 0.0),
      duration: MotionSystem.standard,
      curve: MotionSystem.deceleration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class ContactButton extends StatefulWidget {
  final String label;
  final String helperText;
  final String? iconSvg;
  final IconData? iconData;
  final String url;

  const ContactButton({
    super.key,
    required this.label,
    required this.helperText,
    this.iconSvg,
    this.iconData,
    required this.url,
  });

  @override
  State<ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<ContactButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      final isWeb = uri.scheme == 'http' || uri.scheme == 'https';
      await launchUrl(
        uri,
        mode: isWeb
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isFocused;

    return Semantics(
      button: true,
      label: widget.label,
      child: Tooltip(
        message: widget.helperText,
        waitDuration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x33FFFFFF)),
        ),
        textStyle: GoogleFonts.geist(
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        child: Focus(
          onFocusChange: (v) => setState(() => _isFocused = v),
          child: InkWell(
            onTap: _launchUrl,
            onHover: (v) => setState(() => _isHovered = v),
            onHighlightChanged: (v) => setState(() => _isPressed = v),
            mouseCursor: SystemMouseCursors.click,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                AnimatedContainer(
                  duration: MotionSystem.micro,
                  curve: MotionSystem.deceleration,
                  transform: Matrix4.translationValues(
                    0,
                    isActive ? (_isPressed ? 1 : -4) : 0,
                    0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0x1AFFFFFF)
                        : const Color(0x0AFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isFocused
                          ? const Color(0xFF4F8CFF) 
                          : (isActive
                                ? const Color(0x4DFFFFFF)
                                : const Color(0x1AFFFFFF)),
                      width: _isFocused ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      if (isActive)
                        BoxShadow(
                          color: const Color(0x26FFFFFF),
                          blurRadius: 24,
                          spreadRadius: -4,
                          offset: const Offset(0, 8),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      AnimatedRotation(
                        turns: isActive ? 0.02 : 0.0,
                        duration: MotionSystem.micro,
                        curve: MotionSystem.deceleration,
                        child: widget.iconSvg != null
                            ? SvgPicture.string(
                                widget.iconSvg!,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Icon(
                                widget.iconData,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                      const SizedBox(width: 12),
                      
                      Text(
                        widget.label,
                        style: GoogleFonts.geist(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                AnimatedOpacity(
                  opacity: isActive ? 1.0 : 0.0,
                  duration: MotionSystem.micro,
                  curve: MotionSystem.deceleration,
                  child: AnimatedSlide(
                    offset: isActive ? Offset.zero : const Offset(0, -0.2),
                    duration: MotionSystem.micro,
                    curve: MotionSystem.deceleration,
                    child: Text(
                      widget.helperText,
                      style: GoogleFonts.geist(
                        textStyle: const TextStyle(
                          color: Color(0x8CFFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/connection_data.dart';
import 'widgets/typing_terminal.dart';
import 'widgets/connection_footer.dart';
import 'widgets/github_timeline/github_timeline_widget.dart';

class ConnectionView extends StatelessWidget {
  const ConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cinematic Vignette Overlay: Calms the background constellation
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC050505),
                    Color(0xFF050505),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
        ),
        
        // Master Content Alignment
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720), // Narrower constraints for focus
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 160.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Headline Sequence
                  _ConnectionStaggerReveal(
                    delayMs: 0,
                    child: Text(
                      "LET'S BUILD SOMETHING\nTHAT PEOPLE REMEMBER.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description Sequence
                  _ConnectionStaggerReveal(
                    delayMs: 400,
                    child: Text(
                      "The architecture is ready. The environment is initialized.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.geist(
                        textStyle: const TextStyle(
                          color: Color(0x8CFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  
                  // Terminal Interface Sequence
                  const _ConnectionStaggerReveal(
                    delayMs: 800,
                    child: TypingTerminal(),
                  ),
                  const SizedBox(height: 48),
                  
                  // Interactive Live GitHub Engineering Timeline
                  const _ConnectionStaggerReveal(
                    delayMs: 3500,
                    child: GithubTimelineWidget(),
                  ),
                  const SizedBox(height: 120),
                  
                  // Availability Indicator Sequence
                  const _ConnectionStaggerReveal(
                    delayMs: 4500,
                    child: AvailabilityIndicator(),
                  ),
                  const SizedBox(height: 120),
                  
                  // Signature Footer Sequence
                  const _ConnectionStaggerReveal(
                    delayMs: 5000,
                    child: SignatureFooter(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConnectionStaggerReveal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  
  const _ConnectionStaggerReveal({
    required this.child,
    required this.delayMs,
  });

  @override
  State<_ConnectionStaggerReveal> createState() => _ConnectionStaggerRevealState();
}

class _ConnectionStaggerRevealState extends State<_ConnectionStaggerReveal> {
  bool _startAnim = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) setState(() => _startAnim = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _startAnim ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - value)),
            child: animChild,
          ),
        );
      },
      child: widget.child,
    );
  }
}

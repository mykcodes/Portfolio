import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/utils/motion_system.dart';
import '../../models/project_model.dart';

class EngineeringDocumentView extends StatefulWidget {
  final ProjectModel project;

  const EngineeringDocumentView({super.key, required this.project});

  @override
  State<EngineeringDocumentView> createState() => _EngineeringDocumentViewState();
}

class _EngineeringDocumentViewState extends State<EngineeringDocumentView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          const SizedBox(height: 32),
          
          // 1. Engineering Overview
          const _SectionHeader(title: 'ENGINEERING OVERVIEW'),
          _buildOverviewContent(),
          const SizedBox(height: 48),

          // 2 & 3. Architecture Diagram & Live Data Flow
          const _SectionHeader(title: 'SYSTEM ARCHITECTURE & DATA FLOW'),
          const SizedBox(height: 16),
          _AnimatedArchitectureDiagram(),
          const SizedBox(height: 48),

          // 4. Engineering Decisions
          const _SectionHeader(title: 'TECHNICAL DECISIONS'),
          const SizedBox(height: 16),
          ...widget.project.technicalDecisions.entries.map((e) => _DecisionTile(question: e.key, answer: e.value)),
          const SizedBox(height: 48),

          // 5. Performance Metrics
          const _SectionHeader(title: 'PERFORMANCE METRICS'),
          const SizedBox(height: 16),
          _MetricsGrid(metrics: widget.project.metrics),
          const SizedBox(height: 48),

          // 6. Implementation Timeline
          const _SectionHeader(title: 'IMPLEMENTATION TIMELINE'),
          const SizedBox(height: 16),
          _VerticalTimeline(stages: widget.project.timelineStages),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildOverviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverviewItem('PROBLEM', widget.project.problem, const Color(0xFFF87171)),
        const SizedBox(height: 16),
        _buildOverviewItem('SOLUTION', widget.project.solution, const Color(0xFF60A5FA)),
        const SizedBox(height: 16),
        _buildOverviewItem('IMPACT', widget.project.impact, const Color(0xFF34D399)),
      ],
    );
  }

  Widget _buildOverviewItem(String label, String content, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              textStyle: TextStyle(
                color: accent.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.geist(
              textStyle: const TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4F8CFF), shape: BoxShape.rectangle)),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.geist(
              textStyle: const TextStyle(
                color: Color(0x99FFFFFF),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Architecture Diagram
// =========================================================================
class _AnimatedArchitectureDiagram extends StatefulWidget {
  @override
  State<_AnimatedArchitectureDiagram> createState() => _AnimatedArchitectureDiagramState();
}

class _AnimatedArchitectureDiagramState extends State<_AnimatedArchitectureDiagram> with TickerProviderStateMixin {
  late AnimationController _drawController;
  late AnimationController _flowController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _flowController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _drawController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_isVisible) {
      _isVisible = true;
      _drawController.forward().then((_) {
        _flowController.repeat();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('arch-diagram'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0x03FFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x0AFFFFFF)),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([_drawController, _flowController]),
          builder: (context, child) {
            return CustomPaint(
              painter: _ArchitecturePainter(
                drawProgress: _drawController.value,
                flowProgress: _flowController.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ArchitecturePainter extends CustomPainter {
  final double drawProgress;
  final double flowProgress;

  _ArchitecturePainter({required this.drawProgress, required this.flowProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0x334F8CFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint nodePaint = Paint()
      ..color = const Color(0x0A4F8CFF)
      ..style = PaintingStyle.fill;

    final Paint nodeBorderPaint = Paint()
      ..color = const Color(0xFF4F8CFF).withOpacity(0.5 * drawProgress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Paint textPaint = Paint()
      ..color = const Color(0xCCFFFFFF).withOpacity(drawProgress);

    // Hardcoded nodes for visual effect
    final List<Offset> nodes = [
      Offset(size.width * 0.2, size.height * 0.2), // Frontend
      Offset(size.width * 0.5, size.height * 0.2), // API Gateway
      Offset(size.width * 0.5, size.height * 0.8), // Database
      Offset(size.width * 0.8, size.height * 0.5), // AI / Compute
      Offset(size.width * 0.2, size.height * 0.8), // Cache
    ];

    final List<String> labels = ['CLIENT', 'API GATEWAY', 'DATA STORE', 'COMPUTE', 'CACHE'];

    // Draw lines (Connections)
    if (drawProgress > 0) {
      final connections = [
        [0, 1], [1, 3], [1, 2], [1, 4], [3, 2]
      ];

      for (var conn in connections) {
        final p1 = nodes[conn[0]];
        final p2 = nodes[conn[1]];
        final currentP2 = Offset.lerp(p1, p2, drawProgress)!;
        canvas.drawLine(p1, currentP2, linePaint);
        
        // Flowing particles
        if (drawProgress == 1.0) {
          final Offset particlePos = Offset.lerp(p1, p2, flowProgress)!;
          canvas.drawCircle(
            particlePos, 
            3.0, 
            Paint()..color = const Color(0xFF4F8CFF)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
          );
          canvas.drawCircle(particlePos, 1.5, Paint()..color = Colors.white);
        }
      }
    }

    // Draw nodes
    for (int i = 0; i < nodes.length; i++) {
      if (drawProgress > (i * 0.15)) {
        final double scale = ((drawProgress - (i * 0.15)) * 4).clamp(0.0, 1.0);
        final rect = Rect.fromCenter(center: nodes[i], width: 100 * scale, height: 40 * scale);
        
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), nodePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), nodeBorderPaint);
        
        if (scale > 0.8) {
          final textPainter = TextPainter(
            text: TextSpan(text: labels[i], style: GoogleFonts.jetBrainsMono(textStyle: TextStyle(color: textPaint.color, fontSize: 10, fontWeight: FontWeight.bold))),
            textDirection: TextDirection.ltr,
          )..layout();
          textPainter.paint(canvas, nodes[i] - Offset(textPainter.width / 2, textPainter.height / 2));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ArchitecturePainter old) => true;
}

// =========================================================================
// Engineering Decisions Tile
// =========================================================================
class _DecisionTile extends StatefulWidget {
  final String question;
  final String answer;
  const _DecisionTile({required this.question, required this.answer});

  @override
  State<_DecisionTile> createState() => _DecisionTileState();
}

class _DecisionTileState extends State<_DecisionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x0AFFFFFF)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (val) => setState(() => _expanded = val),
          iconColor: const Color(0xFF4F8CFF),
          collapsedIconColor: const Color(0x59FFFFFF),
          title: Text(
            widget.question,
            style: GoogleFonts.geist(
              textStyle: TextStyle(
                color: _expanded ? const Color(0xFF4F8CFF) : const Color(0xCCFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            Text(
              widget.answer,
              style: GoogleFonts.geist(
                textStyle: const TextStyle(
                  color: Color(0x99FFFFFF),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Metrics Grid with Animated Counters
// =========================================================================
class _MetricsGrid extends StatelessWidget {
  final List<String> metrics;
  const _MetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: metrics.map((m) {
        final RegExp regExp = RegExp(r'(\d+[\.,]?\d*)');
        final match = regExp.firstMatch(m);
        
        return Container(
          width: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x05FFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x0AFFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (match != null) 
                _AnimatedCounter(
                  value: double.parse(match.group(0)!.replaceAll(',', '')),
                  suffix: m.substring(match.end),
                  prefix: m.substring(0, match.start),
                )
              else
                Text(
                  m,
                  style: GoogleFonts.plusJakartaSans(textStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 8),
              Container(width: 24, height: 2, color: const Color(0xFF4F8CFF)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AnimatedCounter extends StatefulWidget {
  final double value;
  final String suffix;
  final String prefix;
  
  const _AnimatedCounter({required this.value, required this.suffix, required this.prefix});

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_isVisible) {
          _isVisible = true;
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          String displayVal = widget.value % 1 == 0 ? _animation.value.toInt().toString() : _animation.value.toStringAsFixed(1);
          return Text(
            '${widget.prefix}$displayVal${widget.suffix}',
            style: GoogleFonts.plusJakartaSans(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// Vertical Timeline
// =========================================================================
class _VerticalTimeline extends StatefulWidget {
  final List<String> stages;
  const _VerticalTimeline({required this.stages});

  @override
  State<_VerticalTimeline> createState() => _VerticalTimelineState();
}

class _VerticalTimelineState extends State<_VerticalTimeline> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('timeline'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_isVisible) {
          _isVisible = true;
          _controller.forward();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.stages.length, (index) {
          final double delay = index / widget.stages.length;
          final double end = (index + 1) / widget.stages.length;
          final Animation<double> lineAnim = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: _controller, curve: Interval(delay, end, curve: Curves.easeOut)),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  AnimatedBuilder(
                    animation: lineAnim,
                    builder: (context, _) => Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF4F8CFF), width: 2),
                        color: lineAnim.value > 0.5 ? const Color(0xFF4F8CFF) : Colors.transparent,
                      ),
                    ),
                  ),
                  if (index < widget.stages.length - 1)
                    AnimatedBuilder(
                      animation: lineAnim,
                      builder: (context, _) => Container(
                        width: 2,
                        height: 40 * lineAnim.value,
                        color: const Color(0x334F8CFF),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              AnimatedBuilder(
                animation: lineAnim,
                builder: (context, _) => Opacity(
                  opacity: lineAnim.value,
                  child: Transform.translate(
                    offset: Offset(10 * (1 - lineAnim.value), 0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        widget.stages[index],
                        style: GoogleFonts.geist(
                          textStyle: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

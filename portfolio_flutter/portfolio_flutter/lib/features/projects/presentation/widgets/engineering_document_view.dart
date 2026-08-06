import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../content/portfolio_data.dart';

class EngineeringDocumentView extends StatefulWidget {
  final ProjectContent project;

  const EngineeringDocumentView({super.key, required this.project});

  @override
  State<EngineeringDocumentView> createState() =>
      _EngineeringDocumentViewState();
}

class _EngineeringDocumentViewState extends State<EngineeringDocumentView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 32),

          
          const _SectionHeader(title: 'ENGINEERING OVERVIEW'),
          _buildOverviewContent(),
          const SizedBox(height: 48),

          
          const _SectionHeader(title: 'TECHNICAL DECISIONS'),
          const SizedBox(height: 16),
          ...widget.project.technicalDecisions.entries.map(
            (e) => _DecisionTile(question: e.key, answer: e.value),
          ),
          const SizedBox(height: 48),

          
          const _SectionHeader(title: 'PERFORMANCE METRICS'),
          const SizedBox(height: 16),
          _MetricsGrid(metrics: widget.project.metrics),
          const SizedBox(height: 48),

          
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
        _buildOverviewItem(
          'PROBLEM',
          widget.project.problem,
          const Color(0xFFF87171),
        ),
        const SizedBox(height: 16),
        _buildOverviewItem(
          'SOLUTION',
          widget.project.solution,
          const Color(0xFF60A5FA),
        ),
        const SizedBox(height: 16),
        _buildOverviewItem(
          'IMPACT',
          widget.project.impact,
          const Color(0xFF34D399),
        ),
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
                color: accent.withValues(alpha: 0.8),
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
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF4F8CFF),
              shape: BoxShape.rectangle,
            ),
          ),
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
                color: _expanded
                    ? const Color(0xFF4F8CFF)
                    : const Color(0xCCFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
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
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

  const _AnimatedCounter({
    required this.value,
    required this.suffix,
    required this.prefix,
  });

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));
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
          String displayVal = widget.value % 1 == 0
              ? _animation.value.toInt().toString()
              : _animation.value.toStringAsFixed(1);
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




class _VerticalTimeline extends StatefulWidget {
  final List<String> stages;
  const _VerticalTimeline({required this.stages});

  @override
  State<_VerticalTimeline> createState() => _VerticalTimelineState();
}

class _VerticalTimelineState extends State<_VerticalTimeline>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
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
          final Animation<double> lineAnim = Tween<double>(begin: 0, end: 1)
              .animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(delay, end, curve: Curves.easeOut),
                ),
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
                        border: Border.all(
                          color: const Color(0xFF4F8CFF),
                          width: 2,
                        ),
                        color: lineAnim.value > 0.5
                            ? const Color(0xFF4F8CFF)
                            : Colors.transparent,
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
                          textStyle: const TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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

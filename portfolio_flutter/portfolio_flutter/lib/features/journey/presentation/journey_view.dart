import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/milestone_data.dart';
import 'widgets/journey_path_painter.dart';
import 'widgets/milestone_card.dart';

class JourneyView extends StatelessWidget {
  final double scrollProgress;

  const JourneyView({
    super.key,
    required this.scrollProgress,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= 1024;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Branding Label Node
              Text(
                'JOURNEY',
                style: GoogleFonts.geist(
                  textStyle: const TextStyle(
                    color: Color(0xFF4F8CFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 6.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Macro Identity Title Headers
              Text(
                "Every engineer starts somewhere.\nMine started with curiosity.",
                style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -1.5,
                  ),
                ),
              ),
              const SizedBox(height: 120),

              // Architectural Timeline Node Stack Canvas
              isDesktop 
                  ? _buildDesktopTimeline(context) 
                  : _buildMobileTimeline(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTimeline(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Background Path Line Painter
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: JourneyPathPainter(
                scrollProgress: scrollProgress,
                pathColor: const Color(0xFF4F8CFF),
              ),
            ),
          ),
        ),

        // Layer 2: Alternate Structural Node Contents
        Column(
          children: List.generate(MilestoneData.milestones.length, (index) {
            final isLeft = index % 2 == 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Row(
                children: [
                  // Left Grid Segment Column
                  Expanded(
                    child: isLeft
                        ? _DiscoveryScrollWrapper(
                            index: index,
                            child: MilestoneCard(
                              milestone: MilestoneData.milestones[index],
                              isLeft: true,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  
                  // Central Waypoint Spatial Core Anchor Gap
                  Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: _TimelineWaypointNode(
                      isActive: scrollProgress >= ((index + 1) / MilestoneData.milestones.length),
                    ),
                  ),

                  // Right Grid Segment Column
                  Expanded(
                    child: !isLeft
                        ? _DiscoveryScrollWrapper(
                            index: index,
                            child: MilestoneCard(
                              milestone: MilestoneData.milestones[index],
                              isLeft: false,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMobileTimeline(BuildContext context) {
    return Column(
      children: List.generate(MilestoneData.milestones.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 64.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TimelineWaypointNode(
                isActive: scrollProgress >= ((index + 1) / MilestoneData.milestones.length),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _DiscoveryScrollWrapper(
                  index: index,
                  child: MilestoneCard(
                    milestone: MilestoneData.milestones[index],
                    isLeft: false,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// =========================================================================
// Enhanced Timeline Waypoint Node — with breathing glow pulse
// =========================================================================
class _TimelineWaypointNode extends StatefulWidget {
  final bool isActive;
  const _TimelineWaypointNode({required this.isActive});

  @override
  State<_TimelineWaypointNode> createState() => _TimelineWaypointNodeState();
}

class _TimelineWaypointNodeState extends State<_TimelineWaypointNode> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulse = widget.isActive ? _pulseController.value : 0.0;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isActive ? const Color(0xFF050505) : const Color(0xFF141416),
            border: Border.all(
              color: widget.isActive ? const Color(0xFF4F8CFF) : const Color(0x33FFFFFF),
              width: 2.0,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F8CFF).withOpacity((0.3 + pulse * 0.3).clamp(0.0, 1.0)),
                      blurRadius: 12 + pulse * 8,
                    )
                  ]
                : [],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 6 + (widget.isActive ? pulse * 2 : 0),
              height: 6 + (widget.isActive ? pulse * 2 : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isActive ? const Color(0xFF4F8CFF) : const Color(0x4DFFFFFF),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DiscoveryScrollWrapper extends StatefulWidget {
  final Widget child;
  final int index;
  const _DiscoveryScrollWrapper({required this.child, required this.index});

  @override
  State<_DiscoveryScrollWrapper> createState() => _DiscoveryScrollWrapperState();
}

class _DiscoveryScrollWrapperState extends State<_DiscoveryScrollWrapper> {
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        setState(() => _animated = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _animated ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 40 * (1.0 - value)),
            child: Transform.scale(
              scale: 0.95 + (0.05 * value),
              child: animChild,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
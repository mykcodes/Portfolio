import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/github_timeline_data.dart';
import '../../../../../core/utils/motion_system.dart';

class GithubTimelineWidget extends StatefulWidget {
  const GithubTimelineWidget({super.key});

  @override
  State<GithubTimelineWidget> createState() => _GithubTimelineWidgetState();
}

class _GithubTimelineWidgetState extends State<GithubTimelineWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Color(0xFF4F8CFF), size: 18),
              const SizedBox(width: 12),
              Text(
                'LIVE ENGINEERING TIMELINE',
                style: GoogleFonts.geist(
                  textStyle: const TextStyle(
                    color: Color(0xFF4F8CFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: GithubTimelineData.recentCommits.length,
            itemBuilder: (context, index) {
              final commit = GithubTimelineData.recentCommits[index];
              return _CommitRow(
                commit: commit,
                isLast: index == GithubTimelineData.recentCommits.length - 1,
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CommitRow extends StatefulWidget {
  final GithubCommit commit;
  final bool isLast;
  final int index;

  const _CommitRow({
    required this.commit,
    required this.isLast,
    required this.index,
  });

  @override
  State<_CommitRow> createState() => _CommitRowState();
}

class _CommitRowState extends State<_CommitRow> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200 + (widget.index * 150)), () {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _isVisible ? 1.0 : 0.0),
      duration: MotionSystem.standard,
      curve: MotionSystem.deceleration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and node
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.commit.isMajor ? const Color(0xFF4F8CFF) : Colors.transparent,
                  border: Border.all(
                    color: widget.commit.isMajor ? const Color(0xFF4F8CFF) : const Color(0x4DFFFFFF),
                    width: 2,
                  ),
                ),
              ),
              if (!widget.isLast)
                Container(
                  width: 2,
                  height: 48,
                  color: const Color(0x1AFFFFFF),
                ),
            ],
          ),
          const SizedBox(width: 24),
          // Commit Data
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.commit.hash,
                      style: GoogleFonts.jetBrainsMono(
                        textStyle: const TextStyle(
                          color: Color(0xFF4F8CFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.commit.date,
                      style: GoogleFonts.geist(
                        textStyle: const TextStyle(
                          color: Color(0x66FFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.commit.message,
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: widget.commit.isMajor ? Colors.white : const Color(0xCCFFFFFF),
                      fontSize: 15,
                      fontWeight: widget.commit.isMajor ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (!widget.isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

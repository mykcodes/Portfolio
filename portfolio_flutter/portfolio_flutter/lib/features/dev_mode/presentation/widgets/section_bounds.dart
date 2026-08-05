import 'package:flutter/material.dart';
import '../../../../core/controllers/experience_controller.dart';

/// Renders subtle colored borders around each section's GlobalKey region.
/// Only visible in Developer Mode. Uses a post-frame callback to read
/// render box positions and draws overlay rectangles.
class SectionBounds extends StatefulWidget {
  const SectionBounds({super.key});

  @override
  State<SectionBounds> createState() => _SectionBoundsState();
}

class _SectionBoundsState extends State<SectionBounds> {
  final Map<String, Rect> _sectionRects = {};

  static const Map<String, Color> _sectionColors = {
    'hero': Color(0xFF4F8CFF),
    'builds': Color(0xFF10B981),
    'journey': Color(0xFFFEBC2E),
    'toolbox': Color(0xFFE879F9),
    'lab': Color(0xFFFF6B6B),
    'connection': Color(0xFF67E8F9),
  };

  @override
  void initState() {
    super.initState();
    ExperienceController.instance.addListener(_recalculate);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalculate());
  }

  void _recalculate() {
    if (!mounted) return;

    final newRects = <String, Rect>{};
    final scrollController = ExperienceController.instance.scrollController;
    if (!scrollController.hasClients) return;

    ExperienceController.instance.sectionKeys.forEach((name, key) {
      final context = key.currentContext;
      if (context != null) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final topLeft = box.localToGlobal(Offset.zero);
          newRects[name] = Rect.fromLTWH(
            topLeft.dx,
            topLeft.dy,
            box.size.width,
            box.size.height,
          );
        }
      }
    });

    if (mounted) {
      setState(() {
        _sectionRects
          ..clear()
          ..addAll(newRects);
      });
    }
  }

  @override
  void dispose() {
    ExperienceController.instance.removeListener(_recalculate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _sectionRects.entries.map((entry) {
        final color = _sectionColors[entry.key] ?? const Color(0xFFFFFFFF);
        final rect = entry.value;
        final isActive = ExperienceController.instance.activeSection == entry.key;

        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: color.withOpacity(isActive ? 0.4 : 0.15),
                  width: isActive ? 1.5 : 0.5,
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    entry.key.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: color.withOpacity(0.8),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

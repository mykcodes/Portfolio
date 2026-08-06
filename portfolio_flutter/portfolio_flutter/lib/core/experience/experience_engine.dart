import 'package:flutter/material.dart';
import 'motion_engine.dart';
import 'cursor_engine.dart';
import 'ambient_engine.dart';
import 'loading_engine.dart';

/// The central nervous system uniting all environmental modules.
class ExperienceEngine extends ChangeNotifier {
  static final ExperienceEngine instance = ExperienceEngine._();
  ExperienceEngine._();

  final CursorEngine cursor = CursorEngine();
  final AmbientEngine ambient = AmbientEngine();
  final LoadingEngine loading = LoadingEngine();
  final ScrollController scrollController = ScrollController();

  double globalScrollProgress = 0.0;
  double maxScrollExtent = 1.0;
  String activeSection = 'hero';

  final Map<String, GlobalKey> sectionKeys = {
    'hero': GlobalKey(),
    'builds': GlobalKey(),
    'journey': GlobalKey(),
    'toolbox': GlobalKey(),
    'lab': GlobalKey(),
    'connection': GlobalKey(),
  };

  void initialize(TickerProvider vsync) {
    ambient.initialize(vsync);
    if (!scrollController.hasListeners) {
      scrollController.addListener(_onScrollStateChanged);
    }
  }

  void _onScrollStateChanged() {
    if (!scrollController.hasClients) return;
    maxScrollExtent = scrollController.position.maxScrollExtent;
    if (maxScrollExtent > 0) {
      globalScrollProgress = (scrollController.offset / maxScrollExtent).clamp(0.0, 1.0);
    }
    _calculateVisibilityIntersections();
    notifyListeners();
  }

  void _calculateVisibilityIntersections() {
    if (scrollController.offset <= 0) {
      if (activeSection != 'hero') {
        activeSection = 'hero';
        notifyListeners();
      }
      return;
    }
    String? dominantSection;
    double minDistance = double.infinity;
    final focalPoint = scrollController.position.viewportDimension * 0.4;

    sectionKeys.forEach((key, globalKey) {
      final context = globalKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final distance = (box.localToGlobal(Offset.zero).dy - focalPoint).abs();
        if (distance < minDistance) {
          minDistance = distance;
          dominantSection = key;
        }
      }
    });

    if (dominantSection != null && dominantSection != activeSection) {
      activeSection = dominantSection!;
      notifyListeners();
    }
  }

  Future<void> scrollToSection(String sectionId) async {
    final key = sectionKeys[sectionId];
    if (key?.currentContext != null) {
      activeSection = sectionId;
      notifyListeners();
      await Scrollable.ensureVisible(
        key!.currentContext!,
        duration: MotionEngine.cinematicDuration,
        curve: MotionEngine.cinematic,
        alignment: 0.1,
      );
    }
  }
}

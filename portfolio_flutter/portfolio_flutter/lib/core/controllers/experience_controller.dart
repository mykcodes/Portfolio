import 'package:flutter/material.dart';
import '../experience/sound_engine.dart';
import '../utils/motion_system.dart';

enum SystemState { booting, waking, active }

/// The Global Experience Engine.
/// Synchronizes all scrolling, ambient lighting, cursor physics, and section visibility.
class ExperienceController extends ChangeNotifier {
  static final ExperienceController instance = ExperienceController._();
  ExperienceController._();

  final ScrollController scrollController = ScrollController();

  // Global State Properties
  SystemState systemState = SystemState.booting;
  // Cursor isolated state to prevent global rebuilds
  final ValueNotifier<Offset> cursorNotifier = ValueNotifier(Offset.zero);
  Offset get globalCursor => cursorNotifier.value;
  double ambientIntensity = 0.0;
  double globalScrollProgress = 0.0; // Tracks precise 0.0 -> 1.0 page depth
  String activeSection = 'hero';
  
  // Prevents scroll listener from fighting the active indicator during manual navigation
  bool _isAutoScrolling = false; 

  // Master Layout Anchors
  final Map<String, GlobalKey> sectionKeys = {
    'hero': GlobalKey(),
    'builds': GlobalKey(),
    'journey': GlobalKey(),
    'toolbox': GlobalKey(),
    'lab': GlobalKey(),
    'connection': GlobalKey(),
  };

  void initialize() {
    if (!scrollController.hasListeners) {
      scrollController.addListener(_onScrollStateChanged);
    }
  }

  void updateCursorPosition(Offset position) {
    if (cursorNotifier.value != position) {
      cursorNotifier.value = position;
    }
  }

  void beginWakeUpSequence() {
    systemState = SystemState.waking;
    notifyListeners();
  }

  void completeWakeUp() {
    systemState = SystemState.active;
    notifyListeners();
  }

  void updateAmbientIntensity(double intensity) {
    ambientIntensity = intensity;
    notifyListeners();
  }

  void _onScrollStateChanged() {
    if (!scrollController.hasClients) return;
    
    final double offset = scrollController.offset;
    final double maxScroll = scrollController.position.maxScrollExtent;
    
    if (maxScroll > 0) {
      globalScrollProgress = (offset / maxScroll).clamp(0.0, 1.0);
      
      // Cinematic Environment Control
      if (globalScrollProgress > 0.75) {
        final double fadeProgress = ((globalScrollProgress - 0.75) / 0.25).clamp(0.0, 1.0);
        ambientIntensity = 1.0 - (fadeProgress * 0.7);
      } else {
        ambientIntensity = 1.0;
      }
    }

    if (!_isAutoScrolling) {
      _determineActiveSection();
    }
    
    notifyListeners();
  }

  /// Calculates which section is currently occupying the focal point of the screen
  void _determineActiveSection() {
    if (!scrollController.hasClients) return;

    // SURGICAL FIX: Lock the active section to 'hero' when at the absolute top.
    // This prevents unpredictable layout-pass geometry (like lazy-loaded modules)
    // from falsely hijacking the active state before the viewport has fully settled.
    if (scrollController.offset <= 0.0) {
      if (activeSection != 'hero') {
        activeSection = 'hero';
      }
      return;
    }
    
    String? visibleSection;
    double minDistance = double.infinity;
    
    final double focalPoint = scrollController.position.viewportDimension * 0.3;

    sectionKeys.forEach((keyName, globalKey) {
      final context = globalKey.currentContext;
      if (context != null) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final double yPos = box.localToGlobal(Offset.zero).dy;
          final double distance = (yPos - focalPoint).abs();
          
          if (distance < minDistance) {
            minDistance = distance;
            visibleSection = keyName;
          }
        }
      }
    });

    if (visibleSection != null && visibleSection != activeSection) {
      activeSection = visibleSection!;
      SoundEngine.instance.playWhoosh();
    }
  }

  /// Global smooth scroll router utilized by the Navigation system
  Future<void> scrollToSection(String sectionName) async {
    final key = sectionKeys[sectionName];
    if (key?.currentContext != null) {
      // 1. Immediately update active state so the navbar indicator glides FIRST.
      _isAutoScrolling = true;
      activeSection = sectionName;
      notifyListeners();

      // 2. Execute the synchronized cinematic scroll.
      await Scrollable.ensureVisible(
        key!.currentContext!,
        duration: MotionSystem.cinematicDuration,
        curve: MotionSystem.cinematic,
        alignment: 0.1,
      );
      
      _isAutoScrolling = false;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollStateChanged);
    scrollController.dispose();
    super.dispose();
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/motion_system.dart';

enum SystemState { booting, waking, active }



class ExperienceController extends ChangeNotifier {
  static final ExperienceController instance = ExperienceController._();
  ExperienceController._();

  final ScrollController scrollController = ScrollController();

  
  SystemState systemState = SystemState.booting;
  
  final ValueNotifier<Offset> cursorNotifier = ValueNotifier(Offset.zero);
  Offset get globalCursor => cursorNotifier.value;
  double ambientIntensity = 0.0;
  double globalScrollProgress = 0.0; 
  String activeSection = 'hero';

  
  bool isMatrixMode = false;
  bool isOverclocked = false;

  
  bool isMobileDrawerOpen = false;

  
  double scrollVelocity = 0.0; 
  double cursorVelocity = 0.0; 
  double _lastScrollOffset = 0.0;
  DateTime _lastScrollTime = DateTime.now();
  Offset _lastCursorPosition = Offset.zero;

  
  bool _isAutoScrolling = false;
  
  bool isScrolling = false;
  Timer? _scrollDebounceTimer;

  
  final Map<String, GlobalKey> sectionKeys = {
    'hero': GlobalKey(),
    'about': GlobalKey(),
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
      
      cursorVelocity = (position - _lastCursorPosition).distance;
      _lastCursorPosition = position;
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

  void toggleMatrixMode() {
    isMatrixMode = !isMatrixMode;
    notifyListeners();
  }

  void toggleOverclock() {
    isOverclocked = !isOverclocked;
    
    if (isOverclocked) {
      Future.delayed(const Duration(seconds: 5), () {
        if (isOverclocked) {
          isOverclocked = false;
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  void toggleMobileDrawer() {
    isMobileDrawerOpen = !isMobileDrawerOpen;
    notifyListeners();
  }

  void _onScrollStateChanged() {
    if (!scrollController.hasClients) return;

    final double offset = scrollController.offset;
    final double maxScroll = scrollController.position.maxScrollExtent;

    
    final now = DateTime.now();
    final dt = now.difference(_lastScrollTime).inMilliseconds;
    if (dt > 0) {
      scrollVelocity = ((offset - _lastScrollOffset) / dt * 1000).abs();
    }
    _lastScrollOffset = offset;
    _lastScrollTime = now;

    if (maxScroll > 0) {
      globalScrollProgress = (offset / maxScroll).clamp(0.0, 1.0);

      
      if (globalScrollProgress > 0.75) {
        final double fadeProgress = ((globalScrollProgress - 0.75) / 0.25)
            .clamp(0.0, 1.0);
        ambientIntensity = 1.0 - (fadeProgress * 0.7);
      } else {
        ambientIntensity = 1.0;
      }
    }

    if (!_isAutoScrolling) {
      _determineActiveSection();
    }

    if (!isScrolling) {
      isScrolling = true;
    }
    
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 150), () {
      isScrolling = false;
      notifyListeners();
    });

    notifyListeners();
  }

  
  void _determineActiveSection() {
    if (!scrollController.hasClients) return;

    
    
    
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
    }
  }

  
  Future<void> scrollToSection(String sectionName) async {
    final key = sectionKeys[sectionName];
    if (key?.currentContext != null) {
      
      _isAutoScrolling = true;
      activeSection = sectionName;
      notifyListeners();

      
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
    _scrollDebounceTimer?.cancel();
    scrollController.removeListener(_onScrollStateChanged);
    scrollController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'experience_controller.dart';






class DevModeController extends ChangeNotifier {
  static final DevModeController instance = DevModeController._();
  DevModeController._();

  bool _isActive = false;
  bool get isActive => _isActive;

  
  Ticker? _fpsTicker;
  int _frameCount = 0;
  DateTime _lastFpsSample = DateTime.now();
  double _currentFps = 0.0;
  double get currentFps => _currentFps;

  
  final List<double> _fpsHistory = [];
  List<double> get fpsHistory => List.unmodifiable(_fpsHistory);

  
  double get scrollVelocity => ExperienceController.instance.scrollVelocity;
  double get cursorVelocity => ExperienceController.instance.cursorVelocity;
  String get activeSection => ExperienceController.instance.activeSection;
  double get scrollProgress =>
      ExperienceController.instance.globalScrollProgress;
  double get ambientIntensity => ExperienceController.instance.ambientIntensity;

  
  int _activeAnimationControllers = 0;
  int get activeAnimationControllers => _activeAnimationControllers;

  void registerAnimationController() {
    _activeAnimationControllers++;
  }

  void unregisterAnimationController() {
    _activeAnimationControllers = (_activeAnimationControllers - 1).clamp(
      0,
      9999,
    );
  }

  void toggle() {
    _isActive = !_isActive;
    if (_isActive) {
      _startFpsTracking();
    } else {
      _stopFpsTracking();
    }
    notifyListeners();
  }

  void _startFpsTracking() {
    _lastFpsSample = DateTime.now();
    _frameCount = 0;
    _fpsTicker = Ticker(_onTick);
    _fpsTicker!.start();
  }

  void _onTick(Duration elapsed) {
    _frameCount++;
    final now = DateTime.now();
    final delta = now.difference(_lastFpsSample).inMilliseconds;

    
    if (delta >= 500) {
      _currentFps = (_frameCount / delta) * 1000.0;
      _frameCount = 0;
      _lastFpsSample = now;

      _fpsHistory.add(_currentFps);
      if (_fpsHistory.length > 60) {
        _fpsHistory.removeAt(0);
      }

      notifyListeners();
    }
  }

  void _stopFpsTracking() {
    _fpsTicker?.stop();
    _fpsTicker?.dispose();
    _fpsTicker = null;
    _fpsHistory.clear();
  }

  
  Map<String, String> get metricsSnapshot => {
    'FPS': _currentFps.toStringAsFixed(1),
    'Scroll Velocity': '${scrollVelocity.toStringAsFixed(1)} px/s',
    'Cursor Velocity': '${cursorVelocity.toStringAsFixed(1)} px/f',
    'Active Section': activeSection,
    'Scroll Progress': scrollProgress.toStringAsFixed(3),
    'Ambient Intensity': ambientIntensity.toStringAsFixed(2),
    'Anim Controllers': '$_activeAnimationControllers',
  };

  @override
  void dispose() {
    _stopFpsTracking();
    super.dispose();
  }
}

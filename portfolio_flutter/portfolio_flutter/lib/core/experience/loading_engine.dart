import 'package:flutter/material.dart';

enum BootPhase { initializing, environmentalWarmup, assemblingModules, ready }

class LoadingEngine extends ChangeNotifier {
  BootPhase currentPhase = BootPhase.initializing;
  double bootProgress = 0.0;

  void advancePhase(BootPhase phase, double progress) {
    currentPhase = phase;
    bootProgress = progress;
    notifyListeners();
  }
}

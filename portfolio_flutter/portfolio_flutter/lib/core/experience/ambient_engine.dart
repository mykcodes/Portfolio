import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


class AmbientEngine extends ChangeNotifier {
  late Ticker _ticker;
  double time = 0.0;
  double breath = 0.0; 

  void initialize(TickerProvider vsync) {
    _ticker = vsync.createTicker((elapsed) {
      time = elapsed.inMilliseconds / 1000.0;
      
      double wave1 = math.sin(time * 0.75);
      double wave2 = math.sin(time * 1.3) * 0.25;
      double combined = wave1 + wave2;
      breath = ((combined / 1.25) + 1.0) / 2.0;
      notifyListeners();
    });
    _ticker.start();
  }

  void disposeEngine() {
    _ticker.dispose();
    super.dispose();
  }
}

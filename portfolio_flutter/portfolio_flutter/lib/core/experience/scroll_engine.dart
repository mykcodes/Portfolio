import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';



class CinematicScrollPhysics extends BouncingScrollPhysics {
  const CinematicScrollPhysics({super.parent});

  @override
  CinematicScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CinematicScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get dragStartDistanceMotionThreshold => 2.0;

  @override
  double get minFlingVelocity => 50.0;

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final tolerance = toleranceFor(position);
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: const SpringDescription(
          mass: 1.2, 
          stiffness: 90.0, 
          damping: 26.0, 
        ),
        position: position.pixels,
        velocity:
            velocity * 0.78, 
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }
}



class CinematicScrollBehavior extends ScrollBehavior {
  const CinematicScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const CinematicScrollPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/controllers/experience_controller.dart';
import '../../../../core/experience/parallax_engine.dart';
import '../../../../core/constants/app_breakpoints.dart';

class ConstellationBackground extends StatefulWidget {
  const ConstellationBackground({super.key});

  @override
  State<ConstellationBackground> createState() =>
      _ConstellationBackgroundState();
}

class _ConstellationBackgroundState extends State<ConstellationBackground>
    with TickerProviderStateMixin {
  late AnimationController _ambientController;
  final Random _random = Random(42);

  
  late List<_StarNode> _deepSpaceNodes;
  late List<_StarNode> _constellationNodes;
  late List<_StarNode> _particleNodes;
  late List<_GeometryNode> _geometryNodes;
  
  late List<_BlueprintPlane> _blueprintPlanes;
  
  late List<_ParametricCurve> _parametricCurves;

  bool _initialized = false;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.sizeOf(context);
      _generateLayers(size);
      _initialized = true;
    }
  }

  void _generateLayers(Size size) {
    double density = 1.0;
    if (size.width < AppBreakpoints.tablet) {
      density = 0.3; // Mobile
    } else if (size.width < AppBreakpoints.desktop) {
      density = 0.6; // Tablet
    } else if (size.width < AppBreakpoints.largeDesktop) {
      density = 0.85; // Desktop
    }

    _deepSpaceNodes = List.generate((150 * density).round(), (index) {
      return _StarNode(
        basePosition: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height * 2,
        ),
        driftSpeed: _random.nextDouble() * 0.2 + 0.05,
        driftPhase: _random.nextDouble() * pi * 2,
        baseSize: _random.nextDouble() * 1.0 + 0.2,
      );
    });

    
    _constellationNodes = List.generate((60 * density).round(), (index) {
      return _StarNode(
        basePosition: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height * 2,
        ),
        driftSpeed: _random.nextDouble() * 0.5 + 0.1,
        driftPhase: _random.nextDouble() * pi * 2,
        baseSize: _random.nextDouble() * 1.5 + 0.5,
      );
    });

    
    _particleNodes = List.generate((40 * density).round(), (index) {
      return _StarNode(
        basePosition: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height * 2,
        ),
        driftSpeed: _random.nextDouble() * 1.5 + 0.5,
        driftPhase: _random.nextDouble() * pi * 2,
        baseSize: _random.nextDouble() * 2.0 + 1.0,
      );
    });

    
    _geometryNodes = List.generate((15 * density).round().clamp(5, 15), (index) {
      return _GeometryNode(
        basePosition: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height * 2,
        ),
        driftSpeed: _random.nextDouble() * 0.3 + 0.1,
        driftPhase: _random.nextDouble() * pi * 2,
        type: index % 3, 
        size: _random.nextDouble() * 40.0 + 20.0,
      );
    });

    
    _blueprintPlanes = List.generate((8 * density).round().clamp(2, 8), (index) {
      return _BlueprintPlane(
        basePosition: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height * 3,
        ),
        width: _random.nextDouble() * 200 + 80,
        height: _random.nextDouble() * 120 + 50,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.08,
        driftPhase: _random.nextDouble() * pi * 2,
        driftSpeed: _random.nextDouble() * 0.15 + 0.03,
      );
    });

    
    _parametricCurves = List.generate((5 * density).round().clamp(1, 5), (index) {
      return _ParametricCurve(
        basePosition: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height * 2.5,
        ),
        amplitude: _random.nextDouble() * 60 + 30,
        frequency: _random.nextDouble() * 2 + 1,
        phaseOffset: _random.nextDouble() * pi * 2,
        driftSpeed: _random.nextDouble() * 0.1 + 0.02,
        length: _random.nextDouble() * 300 + 150,
      );
    });
  }

  late final Paint _primaryFogPaint;
  late final Paint _secondaryFogPaint;
  late final Paint _warmAccentPaint;
  late final Paint _blueprintLinePaint;
  late final Paint _curvePaint;
  late final Paint _deepSpacePaint;
  late final Paint _constellationNodePaint;
  late final Paint _constellationLinePaint;
  late final Paint _geometryPaint;
  late final Paint _particlePaint;

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  Offset _smoothCursor = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _primaryFogPaint = Paint();
    _secondaryFogPaint = Paint();
    _warmAccentPaint = Paint();
    _blueprintLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    _curvePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;
    _deepSpacePaint = Paint()..style = PaintingStyle.fill;
    _constellationNodePaint = Paint()..style = PaintingStyle.fill;
    _constellationLinePaint = Paint()..strokeWidth = 1.0;
    _geometryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    _particlePaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        ExperienceController.instance.scrollController,
        _ambientController,
        ExperienceController.instance,
      ]),
      builder: (context, child) {
        final double globalIntensity =
            ExperienceController.instance.ambientIntensity;
        final Offset targetMouse = ExperienceController.instance.globalCursor;
        final double scrollProgress =
            ExperienceController.instance.globalScrollProgress;
        final String activeSection =
            ExperienceController.instance.activeSection;

        
        if (targetMouse != Offset.zero) {
          if (_smoothCursor == Offset.zero) {
            _smoothCursor = targetMouse;
          } else {
            _smoothCursor =
                Offset.lerp(_smoothCursor, targetMouse, 0.08) ?? targetMouse;
          }
        }

        
        double maxScroll = 5000;
        if (ExperienceController.instance.scrollController.hasClients) {
          maxScroll = ExperienceController
              .instance
              .scrollController
              .position
              .maxScrollExtent;
        }

        return CustomPaint(
          painter: _AtmosphereEnginePainter(
            deepSpaceNodes: _deepSpaceNodes,
            constellationNodes: _constellationNodes,
            particleNodes: _particleNodes,
            geometryNodes: _geometryNodes,
            blueprintPlanes: _blueprintPlanes,
            parametricCurves: _parametricCurves,
            mousePosition: _smoothCursor, 
            time: _ambientController.value * pi * 2,
            globalIntensity: globalIntensity,
            scrollProgress: scrollProgress,
            activeSection: activeSection,
            maxScroll: maxScroll,
            screenSize: MediaQuery.sizeOf(context),
            primaryFogPaint: _primaryFogPaint,
            secondaryFogPaint: _secondaryFogPaint,
            warmAccentPaint: _warmAccentPaint,
            blueprintLinePaint: _blueprintLinePaint,
            curvePaint: _curvePaint,
            deepSpacePaint: _deepSpacePaint,
            constellationNodePaint: _constellationNodePaint,
            constellationLinePaint: _constellationLinePaint,
            geometryPaint: _geometryPaint,
            particlePaint: _particlePaint,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _StarNode {
  final Offset basePosition;
  final double driftSpeed;
  final double driftPhase;
  final double baseSize;
  _StarNode({
    required this.basePosition,
    required this.driftSpeed,
    required this.driftPhase,
    required this.baseSize,
  });
}

class _GeometryNode {
  final Offset basePosition;
  final double driftSpeed;
  final double driftPhase;
  final int type;
  final double size;
  _GeometryNode({
    required this.basePosition,
    required this.driftSpeed,
    required this.driftPhase,
    required this.type,
    required this.size,
  });
}

class _BlueprintPlane {
  final Offset basePosition;
  final double width;
  final double height;
  final double rotationSpeed;
  final double driftPhase;
  final double driftSpeed;
  _BlueprintPlane({
    required this.basePosition,
    required this.width,
    required this.height,
    required this.rotationSpeed,
    required this.driftPhase,
    required this.driftSpeed,
  });
}

class _ParametricCurve {
  final Offset basePosition;
  final double amplitude;
  final double frequency;
  final double phaseOffset;
  final double driftSpeed;
  final double length;
  _ParametricCurve({
    required this.basePosition,
    required this.amplitude,
    required this.frequency,
    required this.phaseOffset,
    required this.driftSpeed,
    required this.length,
  });
}

class _AtmosphereEnginePainter extends CustomPainter {
  final List<_StarNode> deepSpaceNodes;
  final List<_StarNode> constellationNodes;
  final List<_StarNode> particleNodes;
  final List<_GeometryNode> geometryNodes;
  final List<_BlueprintPlane> blueprintPlanes;
  final List<_ParametricCurve> parametricCurves;
  final Offset mousePosition;
  final double time;
  final double globalIntensity;
  final double scrollProgress;
  final String activeSection;
  final double maxScroll;
  final Size screenSize;

  
  final Paint primaryFogPaint;
  final Paint secondaryFogPaint;
  final Paint warmAccentPaint;
  final Paint blueprintLinePaint;
  final Paint curvePaint;
  final Paint deepSpacePaint;
  final Paint constellationNodePaint;
  final Paint constellationLinePaint;
  final Paint geometryPaint;
  final Paint particlePaint;

  _AtmosphereEnginePainter({
    required this.deepSpaceNodes,
    required this.constellationNodes,
    required this.particleNodes,
    required this.geometryNodes,
    required this.blueprintPlanes,
    required this.parametricCurves,
    required this.mousePosition,
    required this.time,
    required this.globalIntensity,
    required this.scrollProgress,
    required this.activeSection,
    required this.maxScroll,
    required this.screenSize,
    required this.primaryFogPaint,
    required this.secondaryFogPaint,
    required this.warmAccentPaint,
    required this.blueprintLinePaint,
    required this.curvePaint,
    required this.deepSpacePaint,
    required this.constellationNodePaint,
    required this.constellationLinePaint,
    required this.geometryPaint,
    required this.particlePaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (globalIntensity <= 0) return;

    
    _paintDeepSpace(canvas, size);

    
    _paintBlueprintPlanes(canvas, size);

    
    _paintParametricCurves(canvas, size);

    
    _paintConstellation(canvas, size);

    
    _paintGeometry(canvas, size);

    
    _paintParticles(canvas, size);

    
    _paintLightingEngine(canvas, size);
  }

  void _paintLightingEngine(Canvas canvas, Size size) {
    if (mousePosition == Offset.zero || globalIntensity <= 0) return;

    canvas.save();
    canvas.translate(mousePosition.dx, mousePosition.dy);

    
    primaryFogPaint.shader = RadialGradient(
      colors: [
        const Color(
          0xFF4F8CFF,
        ).withValues(alpha: (0.10 * globalIntensity).clamp(0.0, 1.0)),
        const Color(
          0xFF4F8CFF,
        ).withValues(alpha: (0.03 * globalIntensity).clamp(0.0, 1.0)),
        const Color(0xFF4F8CFF).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.4, 1.0],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: 350));

    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 2,
        height: size.height * 2,
      ),
      primaryFogPaint,
    );

    
    secondaryFogPaint.shader = RadialGradient(
      colors: [
        const Color(
          0xFF4F8CFF,
        ).withValues(alpha: (0.04 * globalIntensity).clamp(0.0, 1.0)),
        const Color(
          0xFF4F8CFF,
        ).withValues(alpha: (0.01 * globalIntensity).clamp(0.0, 1.0)),
        const Color(0xFF4F8CFF).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.3, 1.0],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: 800));
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 2,
        height: size.height * 2,
      ),
      secondaryFogPaint,
    );

    
    warmAccentPaint.shader = RadialGradient(
      colors: [
        const Color(
          0xFFFFFFFF,
        ).withValues(alpha: (0.02 * globalIntensity).clamp(0.0, 1.0)),
        const Color(0xFFFFFFFF).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: 250));
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 2,
        height: size.height * 2,
      ),
      warmAccentPaint,
    );

    canvas.restore();
  }

  void _paintBlueprintPlanes(Canvas canvas, Size size) {
    final Offset layerOffset = ParallaxEngine.getOffset(
      layer: 0,
      scrollProgress: scrollProgress,
      maxScroll: maxScroll,
      cursorPosition: mousePosition,
      screenSize: screenSize,
    );

    for (var plane in blueprintPlanes) {
      double dx =
          plane.basePosition.dx +
          sin(time * plane.driftSpeed + plane.driftPhase) * 10.0 +
          layerOffset.dx;
      double dy =
          plane.basePosition.dy +
          cos(time * plane.driftSpeed + plane.driftPhase) * 10.0 +
          layerOffset.dy;

      dy = dy % (size.height * 3);
      if (dy < 0) dy += size.height * 3;
      dy -= size.height * 0.5;

      
      final double distToMouse = mousePosition == Offset.zero
          ? 1000.0
          : (Offset(dx, dy) - mousePosition).distance;
      final double proximityBoost =
          (1.0 - (distToMouse / 600.0).clamp(0.0, 1.0)) * 0.02;

      
      final double scrollPhase =
          (scrollProgress * 3 + plane.driftPhase).abs() % 1.0;
      final double scrollOpacity = (sin(scrollPhase * pi) * 0.5 + 0.5) * 0.015;

      
      final double sectionMultiplier = activeSection == 'builds' ? 3.0 : 1.0;

      blueprintLinePaint.color = const Color(0xFF4F8CFF).withValues(
        alpha:
            ((0.025 + proximityBoost + scrollOpacity) *
                    sectionMultiplier *
                    globalIntensity)
                .clamp(0.0, 0.15),
      );

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(time * plane.rotationSpeed);

      
      final Rect rect = Rect.fromCenter(
        center: Offset.zero,
        width: plane.width,
        height: plane.height,
      );
      canvas.drawRect(rect, blueprintLinePaint);

      
      final double thirdW = plane.width / 3;
      final double thirdH = plane.height / 3;
      canvas.drawLine(
        Offset(-plane.width / 2 + thirdW, -plane.height / 2),
        Offset(-plane.width / 2 + thirdW, plane.height / 2),
        blueprintLinePaint,
      );
      canvas.drawLine(
        Offset(-plane.width / 2, -plane.height / 2 + thirdH),
        Offset(plane.width / 2, -plane.height / 2 + thirdH),
        blueprintLinePaint,
      );

      
      const double tickLen = 6.0;
      final double hw = plane.width / 2;
      final double hh = plane.height / 2;
      
      canvas.drawLine(Offset(-hw, -hh + tickLen), Offset(-hw, -hh), blueprintLinePaint);
      canvas.drawLine(Offset(-hw, -hh), Offset(-hw + tickLen, -hh), blueprintLinePaint);
      
      canvas.drawLine(Offset(hw, -hh + tickLen), Offset(hw, -hh), blueprintLinePaint);
      canvas.drawLine(Offset(hw, -hh), Offset(hw - tickLen, -hh), blueprintLinePaint);
      
      canvas.drawLine(Offset(-hw, hh - tickLen), Offset(-hw, hh), blueprintLinePaint);
      canvas.drawLine(Offset(-hw, hh), Offset(-hw + tickLen, hh), blueprintLinePaint);
      
      canvas.drawLine(Offset(hw, hh - tickLen), Offset(hw, hh), blueprintLinePaint);
      canvas.drawLine(Offset(hw, hh), Offset(hw - tickLen, hh), blueprintLinePaint);

      canvas.restore();
    }
  }

  void _paintParametricCurves(Canvas canvas, Size size) {
    final Offset layerOffset = ParallaxEngine.getOffset(
      layer: 1,
      scrollProgress: scrollProgress,
      maxScroll: maxScroll,
      cursorPosition: mousePosition,
      screenSize: screenSize,
    );

    for (var curve in parametricCurves) {
      double baseDx =
          curve.basePosition.dx +
          sin(time * curve.driftSpeed) * 20.0 +
          layerOffset.dx;
      double baseDy =
          curve.basePosition.dy +
          cos(time * curve.driftSpeed) * 20.0 +
          layerOffset.dy;

      baseDy = baseDy % (size.height * 2.5);
      if (baseDy < 0) baseDy += size.height * 2.5;
      baseDy -= size.height * 0.5;

      final Path path = Path();
      bool first = true;

      for (double t = 0; t <= curve.length; t += 3.0) {
        final double x = baseDx + t;
        final double y =
            baseDy +
            sin(t * curve.frequency * 0.02 + time * 0.3 + curve.phaseOffset) *
                curve.amplitude;

        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }

      
      final double midX = baseDx + curve.length / 2;
      final double distToMouse = mousePosition == Offset.zero
          ? 1000.0
          : (Offset(midX, baseDy) - mousePosition).distance;
      final double proximityBoost =
          (1.0 - (distToMouse / 500.0).clamp(0.0, 1.0)) * 0.03;

      
      final double sectionMultiplier = activeSection == 'journey' ? 2.5 : 1.0;

      curvePaint.color = const Color(0xFF4F8CFF).withValues(
        alpha: ((0.03 + proximityBoost) * sectionMultiplier * globalIntensity)
            .clamp(0.0, 0.12),
      );

      canvas.drawPath(path, curvePaint);

      
      final Paint axisPaint = Paint()
        ..color = const Color(
          0xFF4F8CFF,
        ).withValues(alpha: (0.015 * globalIntensity).clamp(0.0, 1.0))
        ..strokeWidth = 0.5;
      canvas.drawLine(
        Offset(baseDx - 15, baseDy),
        Offset(baseDx + 15, baseDy),
        axisPaint,
      );
      canvas.drawLine(
        Offset(baseDx, baseDy - 15),
        Offset(baseDx, baseDy + 15),
        axisPaint,
      );
    }
  }

  void _paintDeepSpace(Canvas canvas, Size size) {
    final Offset layerOffset = ParallaxEngine.getOffset(
      layer: 0,
      scrollProgress: scrollProgress,
      maxScroll: maxScroll,
      cursorPosition: mousePosition,
      screenSize: screenSize,
    );

    for (var node in deepSpaceNodes) {
      double dx =
          node.basePosition.dx +
          sin(time * node.driftSpeed + node.driftPhase) * 5.0 +
          layerOffset.dx;
      double dy =
          node.basePosition.dy +
          cos(time * node.driftSpeed + node.driftPhase) * 5.0 +
          layerOffset.dy;

      dy = dy % (size.height * 2);
      if (dy < 0) dy += size.height * 2;
      dy -= size.height * 0.5;

      
      double proximityBoost = 0.0;
      if (mousePosition != Offset.zero) {
        final double dist = (Offset(dx, dy) - mousePosition).distance;
        proximityBoost = (1.0 - (dist / 400.0).clamp(0.0, 1.0)) * 0.08;
      }

      deepSpacePaint.color = Colors.white.withValues(
        alpha: ((0.15 + proximityBoost) * globalIntensity).clamp(0.0, 1.0),
      );
      canvas.drawCircle(Offset(dx, dy), node.baseSize, deepSpacePaint);
    }
  }

  void _paintConstellation(Canvas canvas, Size size) {
    final Offset layerOffset = ParallaxEngine.getOffset(
      layer: 1,
      scrollProgress: scrollProgress,
      maxScroll: maxScroll,
      cursorPosition: mousePosition,
      screenSize: screenSize,
    );

    final List<Offset> currentPositions = [];
    for (var node in constellationNodes) {
      double dx =
          node.basePosition.dx +
          sin(time * node.driftSpeed + node.driftPhase) * 15.0 +
          layerOffset.dx;
      double dy =
          node.basePosition.dy +
          cos(time * node.driftSpeed + node.driftPhase) * 15.0 +
          layerOffset.dy;

      dy = dy % (size.height * 2);
      if (dy < 0) dy += size.height * 2;
      dy -= size.height * 0.5;

      
      if (mousePosition != Offset.zero) {
        final double distToMouse = (Offset(dx, dy) - mousePosition).distance;
        if (distToMouse < 400 && distToMouse > 0) {
          final double pullFactor = (1.0 - (distToMouse / 400.0)) * 0.05;
          dx += (mousePosition.dx - dx) * pullFactor;
          dy += (mousePosition.dy - dy) * pullFactor;
        }
      }

      currentPositions.add(Offset(dx, dy));
    }

    double connectDistance = 140.0;
    if (activeSection == 'builds') {
      connectDistance = 180.0;
    } else if (activeSection == 'hero') {
      connectDistance = 100.0;
    } else if (activeSection == 'toolbox') {
      connectDistance = 160.0;
    }

    for (int i = 0; i < currentPositions.length; i++) {
      final p1 = currentPositions[i];
      final double distanceToMouse = (p1 - mousePosition).distance;
      final double hoverIntensity = (1.0 - (distanceToMouse / 300)).clamp(
        0.0,
        1.0,
      );

      for (int j = i + 1; j < currentPositions.length; j++) {
        final p2 = currentPositions[j];
        final double distSq = (p1 - p2).distanceSquared;
        final double connectDistSq = connectDistance * connectDistance;

        if (distSq < connectDistSq) {
          final double distance = sqrt(distSq);
          final double baseAlpha = (1.0 - (distance / connectDistance)) * 0.15;
          final double finalAlpha =
              (baseAlpha + (hoverIntensity * 0.3)) * globalIntensity;
          constellationLinePaint.color = Colors.white.withValues(
            alpha: finalAlpha.clamp(0.0, 1.0),
          );
          canvas.drawLine(p1, p2, constellationLinePaint);
        }
      }
    }

    for (int i = 0; i < currentPositions.length; i++) {
      final p = currentPositions[i];
      final node = constellationNodes[i];
      final double distanceToMouse = (p - mousePosition).distance;
      final double hoverScale = distanceToMouse < 200
          ? 1.0 + ((200 - distanceToMouse) / 200)
          : 1.0;

      constellationNodePaint.color = Colors.white.withValues(
        alpha: (0.25 * globalIntensity).clamp(0.0, 1.0),
      );

      if (hoverScale > 1.0) {
        final glowPaint =
            Paint() 
              ..color = const Color(0xFF4F8CFF).withValues(
                alpha: (0.3 * (hoverScale - 1.0) * globalIntensity).clamp(
                  0.0,
                  1.0,
                ),
              )
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
        canvas.drawCircle(p, node.baseSize * hoverScale * 4.0, glowPaint);
      }
      canvas.drawCircle(p, node.baseSize * hoverScale, constellationNodePaint);
    }
  }

  void _paintGeometry(Canvas canvas, Size size) {
    final Offset layerOffset = ParallaxEngine.getOffset(
      layer: 2,
      scrollProgress: scrollProgress,
      maxScroll: maxScroll,
      cursorPosition: mousePosition,
      screenSize: screenSize,
    );

    for (var node in geometryNodes) {
      double dx =
          node.basePosition.dx +
          sin(time * node.driftSpeed + node.driftPhase) * 20.0 +
          layerOffset.dx;
      double dy =
          node.basePosition.dy +
          cos(time * node.driftSpeed + node.driftPhase) * 20.0 +
          layerOffset.dy;

      dy = dy % (size.height * 2);
      if (dy < 0) dy += size.height * 2;
      dy -= size.height * 0.5;

      final p = Offset(dx, dy);

      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(time * node.driftSpeed * 0.5);

      if (node.type == 0) {
        canvas.drawLine(
          Offset(-node.size / 2, 0),
          Offset(node.size / 2, 0),
          geometryPaint,
        );
        canvas.drawLine(
          Offset(0, -node.size / 2),
          Offset(0, node.size / 2),
          geometryPaint,
        );
      } else if (node.type == 1) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: node.size,
            height: node.size,
          ),
          geometryPaint,
        );
      } else {
        canvas.drawCircle(Offset.zero, node.size / 2, geometryPaint);
      }
      canvas.restore();
    }
  }

  void _paintParticles(Canvas canvas, Size size) {
    final Offset layerOffset = ParallaxEngine.getOffset(
      layer: 3,
      scrollProgress: scrollProgress,
      maxScroll: maxScroll,
      cursorPosition: mousePosition,
      screenSize: screenSize,
    );

    for (var node in particleNodes) {
      double dx =
          node.basePosition.dx +
          sin(time * node.driftSpeed * 3 + node.driftPhase) * 30.0 +
          layerOffset.dx;
      double dy =
          node.basePosition.dy +
          cos(time * node.driftSpeed * 3 + node.driftPhase) * 30.0 +
          layerOffset.dy;

      dy = dy % (size.height * 2);
      if (dy < 0) dy += size.height * 2;
      dy -= size.height * 0.5;

      
      double pulseSpeedMultiplier = 1.0;
      double sizeMultiplier = 1.0;
      if (activeSection == 'lab') {
        pulseSpeedMultiplier = 3.0;
        sizeMultiplier = 1.5;
      } else if (activeSection == 'hero') {
        pulseSpeedMultiplier = 0.5;
        sizeMultiplier = 0.8;
      }

      final double pulse =
          (sin(time * 10 * pulseSpeedMultiplier + node.driftPhase) + 1.0) / 2.0;
      particlePaint.color = Colors.white.withValues(
        alpha: (0.4 * pulse * globalIntensity).clamp(0.0, 1.0),
      );

      canvas.drawCircle(
        Offset(dx, dy),
        node.baseSize * sizeMultiplier,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AtmosphereEnginePainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.mousePosition != mousePosition ||
        oldDelegate.globalIntensity != globalIntensity ||
        oldDelegate.scrollProgress != scrollProgress ||
        oldDelegate.activeSection != activeSection ||
        oldDelegate.maxScroll != maxScroll;
  }
}

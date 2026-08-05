import 'dart:math' as math;
import 'dart:ui';
import 'graph_data.dart';

/// Physics engine for the force-directed knowledge graph.
/// Simulates spring-damper dynamics, Coulomb repulsion, and mouse interaction.
class GraphPhysics {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  
  // Physics constants
  final double repulsionConstant = 6000.0;
  final double springLength = 120.0;
  final double springConstant = 0.05;
  final double damping = 0.85;
  final double maxVelocity = 20.0;
  final double mouseRepulsion = 1500.0;
  final double mouseRadius = 150.0;

  Size _bounds = Size.zero;
  Offset _mousePos = Offset.zero;

  GraphPhysics({required this.nodes, required this.edges});

  void updateBounds(Size size) {
    if (_bounds != size && size.width > 0 && size.height > 0) {
      _bounds = size;
      // Initialize unplaced nodes to center with slight random offset
      final random = math.Random(42);
      final center = Offset(size.width / 2, size.height / 2);
      
      for (var node in nodes) {
        if (node.position == Offset.zero) {
          node.position = center + Offset(
            (random.nextDouble() - 0.5) * 100,
            (random.nextDouble() - 0.5) * 100,
          );
        }
      }
    }
  }

  void updateMousePosition(Offset position) {
    _mousePos = position;
  }

  void tick() {
    if (_bounds.width == 0 || _bounds.height == 0) return;

    final center = Offset(_bounds.width / 2, _bounds.height / 2);

    // 1. Calculate repulsion forces between all nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final nodeA = nodes[i];
        final nodeB = nodes[j];

        final delta = nodeB.position - nodeA.position;
        var dist = delta.distance;
        if (dist < 1.0) dist = 1.0;

        // Coulomb repulsion: F = k * (q1*q2) / r^2
        final forceMag = repulsionConstant / (dist * dist);
        final force = (delta / dist) * forceMag;

        nodeA.velocity -= force;
        nodeB.velocity += force;
      }
    }

    // 2. Calculate spring forces along edges
    for (final edge in edges) {
      final nodeA = edge.source;
      final nodeB = edge.target;

      final delta = nodeB.position - nodeA.position;
      var dist = delta.distance;
      if (dist < 1.0) dist = 1.0;

      // Hooke's law: F = -k * (x - L)
      final displacement = dist - springLength;
      final forceMag = springConstant * displacement;
      final force = (delta / dist) * forceMag;

      nodeA.velocity += force;
      nodeB.velocity -= force;
    }

    // 3. Calculate gravity/centering force
    for (final node in nodes) {
      final deltaCenter = center - node.position;
      node.velocity += deltaCenter * 0.01; // Gentle pull to center
    }

    // 4. Mouse interaction
    if (_mousePos != Offset.zero) {
      for (final node in nodes) {
        final deltaMouse = node.position - _mousePos;
        final distMouse = deltaMouse.distance;
        if (distMouse < mouseRadius && distMouse > 0) {
          final pushForce = mouseRepulsion / (distMouse * distMouse);
          node.velocity += (deltaMouse / distMouse) * pushForce;
        }
      }
    }

    // 5. Update positions and apply damping
    for (final node in nodes) {
      // Cap velocity to prevent explosion
      if (node.velocity.distance > maxVelocity) {
        node.velocity = (node.velocity / node.velocity.distance) * maxVelocity;
      }

      node.position += node.velocity;
      node.velocity *= damping;

      // Keep within bounds
      if (node.position.dx < 50) {
        node.position = Offset(50, node.position.dy);
        node.velocity = Offset(-node.velocity.dx * 0.5, node.velocity.dy);
      } else if (node.position.dx > _bounds.width - 50) {
        node.position = Offset(_bounds.width - 50, node.position.dy);
        node.velocity = Offset(-node.velocity.dx * 0.5, node.velocity.dy);
      }

      if (node.position.dy < 50) {
        node.position = Offset(node.position.dx, 50);
        node.velocity = Offset(node.velocity.dx, -node.velocity.dy * 0.5);
      } else if (node.position.dy > _bounds.height - 50) {
        node.position = Offset(node.position.dx, _bounds.height - 50);
        node.velocity = Offset(node.velocity.dx, -node.velocity.dy * 0.5);
      }
    }
  }
}

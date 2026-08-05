import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/experience/sound_engine.dart';
import '../../../../../../core/utils/motion_system.dart';
import '../../../models/skill_model.dart';
import 'graph_data.dart';
import 'graph_physics.dart';

/// Interactive force-directed knowledge graph.
/// Replaces the static skill grid with a physics-simulated node network.
class KnowledgeGraphWidget extends StatefulWidget {
  final Function(SkillModel?) onSkillSelected;
  
  const KnowledgeGraphWidget({
    super.key,
    required this.onSkillSelected,
  });

  @override
  State<KnowledgeGraphWidget> createState() => _KnowledgeGraphWidgetState();
}

class _KnowledgeGraphWidgetState extends State<KnowledgeGraphWidget> with TickerProviderStateMixin {
  late Ticker _ticker;
  late GraphPhysics _physics;
  
  List<GraphNode> _nodes = [];
  List<GraphEdge> _edges = [];
  
  // Interaction state
  GraphNode? _hoveredNode;
  GraphNode? _selectedNode;

  @override
  void initState() {
    super.initState();
    _nodes = GraphData.defaultNodes;
    _edges = GraphData.getEdges(_nodes);
    
    _physics = GraphPhysics(nodes: _nodes, edges: _edges);
    
    _ticker = createTicker((_) {
      _physics.tick();
      if (mounted) setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handleHover(Offset localPosition, Size size) {
    _physics.updateMousePosition(localPosition);

    GraphNode? closestNode;
    double minDistance = 30.0; // Hover hit radius

    for (var node in _nodes) {
      final distance = (node.position - localPosition).distance;
      if (distance < minDistance) {
        minDistance = distance;
        closestNode = node;
      }
    }

    if (_hoveredNode != closestNode) {
      if (closestNode != null) {
        SoundEngine.instance.playHover();
      }
      setState(() {
        _hoveredNode = closestNode;
      });
    }
  }

  void _handleTap(Offset localPosition) {
    if (_hoveredNode != null && _hoveredNode!.skillData != null) {
      SoundEngine.instance.playClick();
      setState(() {
        _selectedNode = _hoveredNode;
      });
      widget.onSkillSelected(_hoveredNode!.skillData);
    } else {
      setState(() {
        _selectedNode = null;
      });
      widget.onSkillSelected(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _physics.updateBounds(size);
        
        // Simple fallback for mobile, interactive graph for desktop
        final isDesktop = size.width >= 768;
        
        if (!isDesktop) {
          // Mobile Fallback: Just return a structured list or wrap since physics graph is hard on small touch screens
          return Center(
             child: Wrap(
               spacing: 8,
               runSpacing: 8,
               alignment: WrapAlignment.center,
               children: _nodes.where((n) => n.skillData != null).map((node) {
                 return GestureDetector(
                   onTap: () {
                     SoundEngine.instance.playClick();
                     widget.onSkillSelected(node.skillData);
                   },
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     decoration: BoxDecoration(
                       color: const Color(0x1AFFFFFF),
                       borderRadius: BorderRadius.circular(8),
                       border: Border.all(color: const Color(0x33FFFFFF)),
                     ),
                     child: Text(
                       node.label,
                       style: GoogleFonts.geist(
                         textStyle: const TextStyle(
                           color: Colors.white,
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                   ),
                 );
               }).toList(),
             ),
          );
        }

        return MouseRegion(
          onHover: (event) => _handleHover(event.localPosition, size),
          onExit: (_) {
            _physics.updateMousePosition(Offset.zero);
            setState(() => _hoveredNode = null);
          },
          cursor: _hoveredNode != null && _hoveredNode!.skillData != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition),
            child: CustomPaint(
              size: size,
              painter: _KnowledgeGraphPainter(
                nodes: _nodes,
                edges: _edges,
                hoveredNode: _hoveredNode,
                selectedNode: _selectedNode,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _KnowledgeGraphPainter extends CustomPainter {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final GraphNode? hoveredNode;
  final GraphNode? selectedNode;

  _KnowledgeGraphPainter({
    required this.nodes,
    required this.edges,
    this.hoveredNode,
    this.selectedNode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Determine connected nodes for highlighting
    final Set<GraphNode> connectedNodes = {};
    if (hoveredNode != null) {
      connectedNodes.add(hoveredNode!);
      for (var edge in edges) {
        if (edge.source == hoveredNode) connectedNodes.add(edge.target);
        if (edge.target == hoveredNode) connectedNodes.add(edge.source);
      }
    } else if (selectedNode != null) {
      connectedNodes.add(selectedNode!);
      for (var edge in edges) {
        if (edge.source == selectedNode) connectedNodes.add(edge.target);
        if (edge.target == selectedNode) connectedNodes.add(edge.source);
      }
    }

    // Draw Edges
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var edge in edges) {
      final isHighlighted = (hoveredNode != null || selectedNode != null) &&
          connectedNodes.contains(edge.source) &&
          connectedNodes.contains(edge.target);
      
      final isDimmed = (hoveredNode != null || selectedNode != null) && !isHighlighted;

      edgePaint.color = isHighlighted
          ? const Color(0x664F8CFF)
          : isDimmed
              ? const Color(0x0AFFFFFF)
              : const Color(0x1AFFFFFF);

      canvas.drawLine(edge.source.position, edge.target.position, edgePaint);
    }

    // Draw Nodes
    for (var node in nodes) {
      final isHovered = node == hoveredNode;
      final isSelected = node == selectedNode;
      final isConnected = connectedNodes.contains(node);
      final isDimmed = (hoveredNode != null || selectedNode != null) && !isConnected;

      // Node Base Paint
      final Color nodeColor = _getCategoryColor(node.category);
      final nodePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isDimmed
            ? const Color(0x1AFFFFFF)
            : nodeColor.withOpacity(isHovered || isSelected ? 1.0 : 0.6);

      final double radius = isHovered || isSelected ? 6.0 : 4.0;
      
      // Draw glow if hovered or selected
      if (isHovered || isSelected) {
        canvas.drawCircle(
          node.position,
          radius * 3,
          Paint()
            ..color = nodeColor.withOpacity(0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      canvas.drawCircle(node.position, radius, nodePaint);

      // Draw Label
      if (!isDimmed) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: node.label,
            style: GoogleFonts.geist(
              textStyle: TextStyle(
                color: isHovered || isSelected ? Colors.white : const Color(0x99FFFFFF),
                fontSize: isHovered || isSelected ? 14 : 12,
                fontWeight: isHovered || isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(node.position.dx + 12, node.position.dy - textPainter.height / 2),
        );
      }
    }
  }

  Color _getCategoryColor(SkillCategory category) {
    switch (category) {
      case SkillCategory.language: return const Color(0xFF4F8CFF); // Blue
      case SkillCategory.framework: return const Color(0xFFE879F9); // Purple
      case SkillCategory.infrastructure: return const Color(0xFF10B981); // Green
      case SkillCategory.domain: return const Color(0xFFFEBC2E); // Yellow
      default: return const Color(0xFFFFFFFF);
    }
  }

  @override
  bool shouldRepaint(covariant _KnowledgeGraphPainter oldDelegate) => true; // Physics runs every frame
}

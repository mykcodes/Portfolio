import 'dart:ui';
import '../../../models/skill_model.dart';
import '../../../data/skills_data.dart';

enum SkillCategory { language, framework, infrastructure, domain }

class GraphNode {
  final String id;
  final String label;
  final SkillCategory category;
  final SkillModel? skillData;
  
  Offset position = Offset.zero;
  Offset velocity = Offset.zero;
  bool isHovered = false;

  GraphNode({
    required this.id,
    required this.label,
    required this.category,
    this.skillData,
  });
}

class GraphEdge {
  final GraphNode source;
  final GraphNode target;

  const GraphEdge(this.source, this.target);
}

class GraphData {
  static List<GraphNode> get defaultNodes {
    final Map<String, GraphNode> nodesMap = {};
    
    // Convert existing skills to nodes
    for (var skill in SkillsData.engineeringModules) {
      nodesMap[skill.name] = GraphNode(
        id: skill.name,
        label: skill.name,
        // Approximate categories based on name
        category: skill.name.contains('Flutter') ? SkillCategory.framework
                : skill.name.contains('Cloud') ? SkillCategory.infrastructure
                : SkillCategory.domain,
        skillData: skill,
      );
    }

    // Add intermediate conceptual nodes for better structure
    final extraNodes = [
      GraphNode(id: 'OOP', label: 'OOP', category: SkillCategory.language),
      GraphNode(id: 'Architecture', label: 'Architecture', category: SkillCategory.language),
      GraphNode(id: 'AI', label: 'AI', category: SkillCategory.domain),
      GraphNode(id: 'LLMs', label: 'LLMs', category: SkillCategory.domain),
      GraphNode(id: 'RAG', label: 'RAG', category: SkillCategory.domain),
      GraphNode(id: 'Cryptography', label: 'Cryptography', category: SkillCategory.domain),
      GraphNode(id: 'Networks', label: 'Networks', category: SkillCategory.domain),
      GraphNode(id: 'CI/CD', label: 'CI/CD', category: SkillCategory.infrastructure),
      GraphNode(id: 'GitHub', label: 'GitHub', category: SkillCategory.infrastructure),
      GraphNode(id: 'Cloud', label: 'Cloud', category: SkillCategory.infrastructure),
    ];

    for (var node in extraNodes) {
      if (!nodesMap.containsKey(node.id)) {
        nodesMap[node.id] = node;
      }
    }

    return nodesMap.values.toList();
  }

  static List<GraphEdge> getEdges(List<GraphNode> nodes) {
    GraphNode? getNode(String id) {
      try {
        return nodes.firstWhere((n) => n.id == id);
      } catch (e) {
        return null;
      }
    }

    final edges = <GraphEdge>[];
    
    void addEdge(String id1, String id2) {
      final n1 = getNode(id1);
      final n2 = getNode(id2);
      if (n1 != null && n2 != null) {
        edges.add(GraphEdge(n1, n2));
      }
    }

    // Languages & Frameworks
    addEdge('Flutter', 'Dart');
    addEdge('Dart', 'OOP');
    addEdge('C++', 'OOP');
    addEdge('Dart', 'Architecture');
    
    // Backend & Infrastructure
    addEdge('Flutter', 'Firebase');
    addEdge('Firebase', 'Cloud');
    addEdge('Git', 'GitHub');
    addEdge('Git', 'CI/CD');
    addEdge('CI/CD', 'Cloud');
    
    // AI & Data
    addEdge('Python', 'FastAPI');
    addEdge('Python', 'AI');
    addEdge('AI', 'LLMs');
    addEdge('LLMs', 'RAG');
    
    // Cybersecurity
    addEdge('Cybersecurity', 'Cryptography');
    addEdge('Cybersecurity', 'Networks');

    return edges;
  }
}

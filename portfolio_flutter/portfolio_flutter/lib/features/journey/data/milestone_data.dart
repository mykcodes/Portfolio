import '../models/milestone_model.dart';

class MilestoneData {
  static const List<MilestoneModel> milestones = [
    MilestoneModel(
      commitHash: 'a7f39b1',
      logDate: '2024.1',
      title: 'SYSTEM.INIT',
      story: 'Discovered the foundational mechanics of software engineering. Began compiling the first mental models of computation.',
      technologies: ['C++', 'Logic Design', 'Algorithms'],
      architectureNotes: 'Focus on low-level memory management and computational complexity to build a resilient foundation.',
    ),
    MilestoneModel(
      commitHash: 'd4e82c9',
      logDate: '2025.2',
      title: 'UI.RENDER_ENGINE',
      story: 'Transitioned from terminal logic to spatial interfaces. Mastered declarative UI rendering through Flutter and reactive state.',
      technologies: ['Flutter', 'Dart', 'Firebase'],
      architectureNotes: 'Implemented unidirectional data flows and modular widget composition to eliminate UI state tearing.',
    ),
    MilestoneModel(
      commitHash: 'f10a56d',
      logDate: '2026.3',
      title: 'CLOUD.INTEGRATION',
      story: 'Expanded into distributed systems. Connected edge applications to centralized cloud logic and AI inference endpoints.',
      technologies: ['AI', 'Cloud', 'Cybersecurity'],
      architectureNotes: 'Secured API gateways, optimized payload transmission, and integrated LLM orchestration layers.',
    ),
    MilestoneModel(
      commitHash: 'HEAD',
      logDate: 'FUTURE',
      title: 'SCALE.INFINITE',
      story: 'Continuous deployment of highly optimized, native-feeling experiences that run everywhere and reach millions.',
      technologies: ['Systems Design', 'Performance', '∞'],
      architectureNotes: 'Goal: Zero frame drops, perfect memory safety, and sub-millisecond interaction latency.',
    ),
  ];
}

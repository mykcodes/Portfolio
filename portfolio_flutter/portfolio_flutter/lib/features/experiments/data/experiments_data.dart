import '../models/experiment_model.dart';

class ExperimentsData {
  static const List<ExperimentModel> labCapsules = [
    ExperimentModel(
      title: 'WebGL Render Pipeline Override',
      status: ExperimentStatus.building,
      progress: 7,
      engineeringNotes: 'Memory leaks detected at 120Hz. Optimizing fragment shader buffers. Bypassing standard Skia draw calls for direct GPU memory allocation.',
      technologyStack: ['Dart FFI', 'OpenGL', 'CanvasKit'],
      difficulty: 'Extreme',
      currentObjective: 'Stabilize continuous frame-time under 4ms.',
      estimatedCompletion: 'Q4 2026',
      lastUpdated: '04 AUG 2026',
      size: CapsuleSize.large,
    ),
    ExperimentModel(
      title: 'Local Edge Intelligence',
      status: ExperimentStatus.researching,
      progress: 3,
      engineeringNotes: 'Evaluating quantized LLM performance on mobile ARM architecture. Context window constrained by thermal throttling.',
      technologyStack: ['TensorFlow Lite', 'Gemini Nano', 'Isolates'],
      difficulty: 'High',
      currentObjective: 'Achieve 15 tokens/sec local inference.',
      estimatedCompletion: 'Q1 2027',
      lastUpdated: '28 JUL 2026',
      size: CapsuleSize.medium,
    ),
    ExperimentModel(
      title: 'Zero-Trust Node Sync',
      status: ExperimentStatus.exploring,
      progress: 5,
      engineeringNotes: 'Implementing asymmetric cryptographic handshakes for P2P state synchronization without a centralized relay server.',
      technologyStack: ['Cryptography', 'WebSockets', 'Protobuf'],
      difficulty: 'High',
      currentObjective: 'Verify secure channel tunneling over NAT.',
      estimatedCompletion: 'Q3 2026',
      lastUpdated: '12 AUG 2026',
      size: CapsuleSize.medium,
    ),
    ExperimentModel(
      title: 'Haptic Spatial Audio',
      status: ExperimentStatus.testing,
      progress: 8,
      engineeringNotes: 'Mapping 3D sound vectors to device linear actuators. Synthesizing physical textures from frequency waves.',
      technologyStack: ['Audio Engine', 'C++', 'Hardware APIs'],
      difficulty: 'Medium',
      currentObjective: 'Calibrate resonance frequencies.',
      estimatedCompletion: 'SEP 2026',
      lastUpdated: '15 AUG 2026',
      size: CapsuleSize.small,
    ),
  ];
}
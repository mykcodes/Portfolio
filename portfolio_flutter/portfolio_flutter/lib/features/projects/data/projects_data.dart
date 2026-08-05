import '../models/project_model.dart';

class ProjectsData {
  static const List<ProjectModel> featuredBuilds = [
    ProjectModel(
      title: 'Neural Node Synchronizer',
      shortDescription: 'A real-time distributed state management system utilizing edge nodes.',
      role: 'Lead Architect',
      timeline: '2025 – 2026',
      engineeringChallenge: 'Maintaining sub-10ms state synchronization across geographically isolated edge devices while accounting for dynamic packet loss.',
      architectureNotes: '> IMPLEMENTED custom UDP protocol with predictive dead-reckoning.\n> BYPASSED standard TCP handshake for 40% latency reduction.',
      techStack: ['Dart FFI', 'C++', 'WebSockets', 'Protobuf'],
      metrics: ['< 8ms Latency', '99.9% Uptime', 'Zero-Trust'],
      problem: 'Geographically dispersed edge devices required real-time state synchronization, but standard HTTP polling and TCP handshakes introduced unacceptable overhead (>150ms latency), leading to desynchronized local states.',
      solution: 'Architected a custom UDP-based protocol bypassing TCP handshakes entirely. Integrated a predictive dead-reckoning engine running locally on the nodes to mask packet loss and interpolate state between ticks.',
      impact: 'Achieved sub-10ms perceived latency globally. Reduced network bandwidth consumption by 65% by switching from JSON over HTTP to binary Protobuf payloads.',
      technicalDecisions: {
        'Why Dart FFI': 'Required to interface the high-performance C++ networking core directly with the Flutter/Dart application layer without channel overhead.',
        'Why UDP over TCP': 'TCP head-of-line blocking was fatal for real-time state. UDP allowed dropping stale packets in favor of the newest state.',
        'Why Dead-Reckoning': 'To provide 144Hz smooth UI updates even when network ticks arrive at only 20Hz.'
      },
      timelineStages: ['Architecture Draft', 'C++ Core Engine', 'Dart FFI Bridge', 'Cloud Deployment'],
      githubUrl: 'https://github.com/mykcodes/neural-node',
      demoUrl: 'https://demo.mykcodes.com',
    ),
    ProjectModel(
      title: 'Quantum Fluid Renderer',
      shortDescription: 'High-performance WebGL fluid simulation running natively in Flutter.',
      role: 'Graphics Engineer',
      timeline: 'Early 2026',
      engineeringChallenge: 'Rendering 100,000+ fluid particles at 120 FPS on mobile web browsers without thermal throttling the GPU.',
      architectureNotes: '> OFFLOADED physics calculations to parallel Web Workers.\n> CUSTOM fragment shaders written directly in GLSL.',
      techStack: ['Flutter Web', 'WebGL', 'GLSL', 'Isolates'],
      metrics: ['120 FPS Target', '100k Particles', 'Minimal GC Pause'],
      problem: 'Standard Flutter Canvas operations were bottlenecking on the CPU when attempting to simulate thousands of fluid particles, resulting in single-digit framerates and massive garbage collection pauses.',
      solution: 'Bypassed the standard rendering pipeline by interfacing directly with WebGL. Offloaded the Navier-Stokes physics calculations to background isolates (Web Workers), passing only a typed array of positions to the GPU.',
      impact: 'Scaled from 1,000 particles at 30 FPS to 100,000 particles at a locked 120 FPS. Completely eliminated UI thread stutter by moving memory allocation out of the main isolate.',
      technicalDecisions: {
        'Why GLSL Shaders': 'CPU physics calculations scale linearly. GPU shaders compute particle positions in parallel, providing a 100x performance multiplier.',
        'Why TypedArrays': 'Avoided the heavy overhead of Dart object allocation and garbage collection by using raw contiguous memory buffers.',
        'Why Flutter Web': 'Provided a unified codebase to deliver the simulation to both mobile and desktop browsers instantly.'
      },
      timelineStages: ['Physics Engine', 'WebGL Integration', 'Shader Optimization', 'Mobile Profiling'],
      githubUrl: 'https://github.com/mykcodes/fluid-render',
    ),
  ];
}
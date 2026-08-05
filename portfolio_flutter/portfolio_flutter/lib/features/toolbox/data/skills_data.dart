import '../models/skill_model.dart';

class SkillsData {
  static const List<SkillModel> engineeringModules = [
    SkillModel(
      name: 'Flutter',
      description: 'Cross-platform native architecture rendering engine.',
      fullEngineeringDescription: 'Leveraging customized render pipeline implementations, engine-level method channels, and strict layered feature isolation structures to deploy sub-60fps compiled desktop and web products.',
      linkedProjects: ['MYK-CODES Portfolio', 'AI Study Assistant'],
      yearsOfExperience: '2 Years',
      currentFocus: 'WebGL canvas integration optimizations and low-overhead frame-rendering pipelines.',
      tags: ['Native Rendering', 'Dart Architecture', 'Skia / Impeller Engine'],
    ),
    SkillModel(
      name: 'Artificial Intelligence',
      description: 'Context-aware intelligence and inference framework layers.',
      fullEngineeringDescription: 'Architecting local orchestration systems utilizing Gemini and generalized multimodal embeddings. Engineering intelligent parsing models linked with vector indices.',
      linkedProjects: ['AI Study Assistant'],
      yearsOfExperience: '1 Year',
      currentFocus: 'Stateful conversational tree mapping and multi-agent workflow pipelines.',
      tags: ['LLM Orchestration', 'RAG Implementations', 'OCR Pipelines'],
    ),
    SkillModel(
      name: 'Cloud Infrastructure',
      description: 'Scalable distributed cloud computing architectures.',
      fullEngineeringDescription: 'Structuring high-availability microservices platforms with programmatic resource separation, zero-trust edge termination zones, and isolated data flow channels.',
      linkedProjects: ['Future Enterprise Nodes'],
      yearsOfExperience: '1 Year',
      currentFocus: 'Automated CI/CD infrastructure generation and encrypted state management paths.',
      tags: ['Cloud Dev', 'Microservices', 'Zero-Trust Networks'],
    ),
    SkillModel(
      name: 'Cybersecurity',
      description: 'Defensive utility testing and network packet logic analysis.',
      fullEngineeringDescription: 'Implementing systematic cryptographic controls, secure handshake verifications, and custom system security protocols to evaluate runtime environment integrity anomalies.',
      linkedProjects: ['Security Core Placeholder'],
      yearsOfExperience: '1 Year',
      currentFocus: 'Analyzing localized system vulnerabilities and designing safe data transmission corridors.',
      tags: ['Cryptography', 'Security Operations', 'Network Analysis'],
    ),
  ];
}
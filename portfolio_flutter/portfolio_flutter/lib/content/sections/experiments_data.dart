import '../models/experiment_model.dart';

class ExperimentsData {
  static const List<ExperimentModel> labCapsules = [

    ExperimentModel(
      title: 'Cloud & Cybersecurity Roadmap',
      status: ExperimentStatus.building,
      progress: 2,
      engineeringNotes:
          'Currently building strong fundamentals in Linux, networking, cloud computing, and cybersecurity. Following a structured roadmap while documenting practical labs and concepts.',
      technologyStack: [
        'Linux',
        'Networking',
        'Cloud',
        'Cybersecurity',
      ],
      difficulty: 'Learning',
      currentObjective:
          'Build a solid foundation before moving to real-world security projects and cloud deployments.',
      estimatedCompletion: 'Ongoing',
      lastUpdated: 'Present',
      size: CapsuleSize.large,
    ),

    ExperimentModel(
      title: 'Engineering Fundamentals',
      status: ExperimentStatus.researching,
      progress: 3,
      engineeringNotes:
          'Strengthening problem-solving through DSA while expanding practical development skills with Python and Flutter. Every concept is reinforced by building real projects.',
      technologyStack: [
        'DSA',
        'Python',
        'Flutter',
        'Git',
      ],
      difficulty: 'Learning',
      currentObjective:
          'Develop the technical depth required to build scalable software and solve complex engineering problems.',
      estimatedCompletion: 'Continuous',
      lastUpdated: 'Present',
      size: CapsuleSize.medium,
    ),
  ];
}
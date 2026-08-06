enum CapsuleSize { large, medium, small }

enum ExperimentStatus { researching, exploring, building, testing }

extension ExperimentStatusExtension on ExperimentStatus {
  String get label => name.toUpperCase();
}

class ExperimentModel {
  final String title;
  final ExperimentStatus status;
  final int progress; 
  final String engineeringNotes;
  final List<String> technologyStack;
  final String difficulty;
  final String currentObjective;
  final String estimatedCompletion;
  final String lastUpdated;
  final CapsuleSize size;

  const ExperimentModel({
    required this.title,
    required this.status,
    required this.progress,
    required this.engineeringNotes,
    required this.technologyStack,
    required this.difficulty,
    required this.currentObjective,
    required this.estimatedCompletion,
    required this.lastUpdated,
    required this.size,
  });
}

class ProjectModel {
  final String title;
  final String shortDescription;
  final String role;
  final String timeline;
  final String engineeringChallenge;
  final String architectureNotes;
  final List<String> techStack;
  final List<String> metrics;
  final String problem;
  final String solution;
  final String impact;
  final Map<String, String> technicalDecisions;
  final List<String> timelineStages;
  final String? githubUrl;
  final String? demoUrl;

  const ProjectModel({
    required this.title,
    required this.shortDescription,
    required this.role,
    required this.timeline,
    required this.engineeringChallenge,
    required this.architectureNotes,
    required this.techStack,
    required this.metrics,
    required this.problem,
    required this.solution,
    required this.impact,
    required this.technicalDecisions,
    required this.timelineStages,
    this.githubUrl,
    this.demoUrl,
  });
}

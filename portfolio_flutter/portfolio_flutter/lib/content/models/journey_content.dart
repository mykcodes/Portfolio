class JourneyContent {
  final String commitHash;
  final String logDate;
  final String title;
  final String story;
  final List<String> technologies;
  final String architectureNotes;

  const JourneyContent({
    required this.commitHash,
    required this.logDate,
    required this.title,
    required this.story,
    required this.technologies,
    this.architectureNotes = '',
  });
}

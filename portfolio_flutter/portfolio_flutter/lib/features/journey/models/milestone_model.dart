class MilestoneModel {
  final String commitHash;
  final String logDate;
  final String title;
  final String story;
  final List<String> technologies;
  final String architectureNotes;

  const MilestoneModel({
    required this.commitHash,
    required this.logDate,
    required this.title,
    required this.story,
    required this.technologies,
    this.architectureNotes = '',
  });
}

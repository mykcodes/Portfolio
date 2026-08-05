class SkillModel {
  final String name;
  final String description;
  final String fullEngineeringDescription;
  final List<String> linkedProjects;
  final String yearsOfExperience;
  final String currentFocus;
  final List<String> tags;

  const SkillModel({
    required this.name,
    required this.description,
    required this.fullEngineeringDescription,
    required this.linkedProjects,
    required this.yearsOfExperience,
    required this.currentFocus,
    required this.tags,
  });
}

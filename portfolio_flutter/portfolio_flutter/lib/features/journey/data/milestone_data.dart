import '../models/milestone_model.dart';

class MilestoneData {
  static const List<MilestoneModel> milestones = [
    MilestoneModel(
      year: '2024',
      title: 'The Beginning',
      story: 'Discovered programming. Began learning with curiosity.',
      technologies: ['C++', 'Problem Solving'],
    ),
    MilestoneModel(
      year: '2025',
      title: 'Building Products',
      story: 'Started creating real projects. Explored Flutter. Focused on design.',
      technologies: ['Flutter', 'Firebase', 'Git'],
    ),
    MilestoneModel(
      year: '2026',
      title: 'AI + Cloud',
      story: 'Building intelligent systems. Exploring Cloud. Learning Cybersecurity.',
      technologies: ['AI', 'Cloud', 'Cybersecurity'],
    ),
    MilestoneModel(
      year: 'Future',
      title: 'Evolution',
      story: 'Building software that reaches millions.',
      technologies: ['∞'],
    ),
  ];
}
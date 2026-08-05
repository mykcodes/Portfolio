/// System-wide route keys and path definitions.
/// Keeping these strings isolated guarantees compile-time safety across features.
class AppRoutes {
  AppRoutes._();

  // Route Names
  static const String homeName = 'home';
  static const String projectsName = 'projects';
  static const String contactName = 'contact';

  // Route Paths
  static const String homePath = '/';
  static const String projectsPath = '/projects';
  static const String contactPath = '/contact';
}
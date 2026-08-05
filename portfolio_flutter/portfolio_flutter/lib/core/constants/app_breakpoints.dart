/// Standardized breakpoint widths for the application.
/// These values define the upper boundaries for device categories.
class AppBreakpoints {
  AppBreakpoints._();

  // Anything below 768 is considered Mobile.
  static const double mobile = 768.0;

  // Anything between 768 and 1024 is considered Tablet.
  // Anything 1024 and above is considered Desktop.
  static const double tablet = 1024.0;
}

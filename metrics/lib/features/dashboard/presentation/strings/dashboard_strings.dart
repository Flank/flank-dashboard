class DashboardStrings {
  static const String buildTaskName = 'Build task name';
  static const String performance = 'PERFORMANCE';
  static const String builds = 'BUILDS';
  static const String stability = 'STABILITY';
  static const String coverage = 'COVERAGE';
  static const String loadMetrics = 'Load metrics';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occured during loading: $errorMessage";
}

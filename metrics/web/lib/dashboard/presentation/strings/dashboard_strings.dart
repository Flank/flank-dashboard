// ignore_for_file: public_member_api_docs

/// Holds the strings for the dashboard screen.
class DashboardStrings {
  static const String performance = 'Performance';
  static const String builds = 'Builds';
  static const String lastBuilds = 'Last 30 builds';
  static const String stability = 'Stability';
  static const String coverage = 'Coverage';
  static const String loadMetrics = 'Load metrics';
  static const String noConfiguredProjects = 'No configured projects';
  static const String noDataPlaceholder = '-';
  static const String perWeek = '/ week';
  static const String noSearchResults = 'No results for projects search…';
  static const String lastBuildsDescription =
      'The build results and duration of the last 30 builds. '
      'Build results can be successful, failed, or unknown.';
  static const String performanceDescription =
      'An average build duration of successful builds by the last 7 days, '
      'excluding the queue time.';
  static const String buildsDescription =
      'The count of performed builds of the project per week.';
  static const String stabilityDescription =
      'A ratio of successful builds to all builds for the last 30 builds.';
  static const String coverageDescription =
      "A last successful build's code coverage percent.";
}

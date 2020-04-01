/// Holds the strings that uses across the project.
///
/// Preferably, add the string to this file instead of hardcoding them into UI
/// to make them available in tests and avoid code duplication.
class CommonStrings {
  static const String metrics = 'Metrics';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occured during loading: $errorMessage";
}

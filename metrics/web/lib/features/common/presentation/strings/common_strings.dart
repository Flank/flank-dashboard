/// Holds the strings used across the whole project.
///
/// Preferably, add the string to this file instead of hardcoding them into UI
/// to make them available in tests and avoid code duplication.
class CommonStrings {
  static const String metrics = 'Metrics';
  static const String logOut = 'Log out';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occurred during loading: $errorMessage";
}

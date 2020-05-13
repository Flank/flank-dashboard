/// Holds the strings used across the whole project.
class CommonStrings {
  static const String metrics = 'metrics';
  static const String logOut = 'Log out';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occurred during loading: $errorMessage";
}

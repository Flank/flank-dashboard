/// Holds the strings used across the whole project.
class CommonStrings {
  static const String metrics = 'metrics';
  static const String logOut = 'Log out';
  static const String searchForProject = 'Search for project...';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String unknownErrorMessage = 'An unknown error occurred';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occurred during loading: $errorMessage";
}

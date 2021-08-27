// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:duration/duration.dart';

// ignore_for_file: public_member_api_docs

/// Holds the strings used across the whole project.
class CommonStrings {
  static const String home = 'Home';
  static const String darkTheme = 'Dark theme';
  static const String lightTheme = 'Light theme';
  static const String projectGroups = 'Project groups';
  static const String navigateBack = 'Back';
  static const String openUserMenu = 'Open user menu';
  static const String closeUserMenu = 'Close user menu';
  static const String metrics = 'metrics';
  static const String welcomeMetrics = 'Welcome to Metrics';
  static const String logOut = 'Logout';
  static const String signIn = 'Sign in';
  static const String searchForProject = 'Search for project...';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String users = 'Users';
  static const String unknownErrorMessage =
      'An unknown error occurred, please try again.';
  static const String openConnectionFailedErrorMessage =
      'An error occurred while opening a connection with the persistent store, please try again.';
  static const String readErrorMessage =
      'An error occurred while reading from the persistent store, please try again.';
  static const String updateErrorMessage =
      'An error occurred while updating the persistent store, please try again.';
  static const String closeConnectionFailedErrorMessage =
      'An error occurred while closing a connection with the persistent store, please try again.';
  static const String debugMenu = 'Debug menu';

  static String duration(Duration duration) => prettyDuration(
        duration,
        abbreviated: true,
        spacer: '',
        delimiter: ' ',
      );

  static String getLoadingErrorMessage(String errorMessage) =>
      'An error occurred during loading: $errorMessage';
}

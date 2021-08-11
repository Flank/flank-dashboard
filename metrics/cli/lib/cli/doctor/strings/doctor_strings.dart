// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds strings used within the doctor command.
class DoctorStrings {
  static const String notInstalled = 'Not installed';
  static const String recommendedVersion = 'recommended version';
  static const String version = 'version';
  static const String processOutput = 'Process output...';
  static const String commandNotFound = 'command not found:';
  static const String recommendations = 'Recommendations...';
  static const String warning = 'Warning message...';
  static const String commandError = 'Command Error Message...';
  static const String versionMismatch = 'Versions mismatch does not guarantee '
      'the successful deployment! We advise to use the recommended version'
      ' of the tool.';
  static String installMessage(String name, String installUrl) {
    return 'Install $name ($installUrl)';
  }

  static String updateMessage(String installUrl) {
    return 'Update version ($installUrl)';
  }
}

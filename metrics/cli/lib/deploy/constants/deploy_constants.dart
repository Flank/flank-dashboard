// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that holds the constants for the deployment process.
class DeployConstants {
  /// A URL to the Metrics repository.
  static const String repoURL = 'git@github.com:platform-platform/monorepo.git';

  /// A name of a temporary directory.
  static const String tempDir = 'tempDir';

  /// A path to the Web project sources.
  static const String webPath = '$tempDir/metrics/web';

  /// A path to the built directory of the Metrics Web project.
  static const String buildWebPath = '$webPath/build/web';

  /// A path to the Metrics configuration file.
  static const String metricsConfigPath = '$buildWebPath/metrics_config.js';

  /// A path to the Firebase sources.
  static const String firebasePath = '$tempDir/metrics/firebase';

  /// A path to the Firebase functions sources.
  static const String firebaseFunctionsPath = '$firebasePath/functions';

  /// A Firebase Hosting target name.
  static const String firebaseTarget = 'metrics';

  /// Returns the name of a temporary directory with the given [suffix].
  static String tempDir(String suffix) => 'tempDir_$suffix';

  /// Returns the path to the Web project sources based on the given [tempDir].
  static String webPath(String tempDir) => '$tempDir/metrics/web';

  /// Returns the path to the Firebase sources based on the given [tempDir].
  static String firebasePath(String tempDir) => '$tempDir/metrics/firebase';

  /// Returns the path to the Firebase functions sources based on
  /// the given [tempDir].
  static String firebaseFunctionsPath(String tempDir) =>
      '${firebasePath(tempDir)}/functions';

  /// Returns the path to the Metrics configuration file based on
  /// the given [tempDir].
  static String metricsConfigPath(String tempDir) =>
      '${webPath(tempDir)}/build/web/metrics_config.js';

  /// A Sentry environment name.
  static const String sentryEnvironment = 'metrics';
}

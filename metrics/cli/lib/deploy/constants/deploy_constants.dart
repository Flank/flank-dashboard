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

  /// A Sentry environment name.
  static const String sentryEnvironment = 'metrics';
}

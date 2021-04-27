// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that holds the constants for the deployment process.
class DeployConstants {
  /// A URL to the Metrics repository.
  static const String repoURL = 'git@github.com:platform-platform/monorepo.git';

  /// A Firebase Hosting target name.
  static const String firebaseTarget = 'metrics';

  /// A name of a temporary directory.
  static String tempDir([String suffix]) =>
      suffix == null ? 'tempDir' : 'tempDir_$suffix';

  /// A path to the Web project sources based on the given [tempDir].
  static String webPath(String tempDir) => '$tempDir/metrics/web';

  /// A path to the Firebase sources based on the given [tempDir].
  static String firebasePath(String tempDir) => '$tempDir/metrics/firebase';

  /// A path to the Firebase functions sources based on the given [tempDir].
  static String firebaseFunctionsPath(String tempDir) =>
      '${firebasePath(tempDir)}/functions';

  /// A path to the Metrics configuration file based on the given [tempDir].
  static String metricsConfigPath(String tempDir) =>
      '${webPath(tempDir)}/build/web/metrics_config.js';
}

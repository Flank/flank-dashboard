// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that holds the paths for the deployment process.
class DeployPaths {
  /// Returns the name of a temporary directory with the given [suffix].
  static String tempDir(String suffix) => 'tempDir_$suffix';

  /// Returns the path to the Web project sources based on the given [tempDir].
  static String web(String tempDir) => '$tempDir/metrics/web';

  /// Returns the path to the built directory of the Metrics Web project.
  static String buildWeb(String tempDir) => '$tempDir/build/web';

  /// Returns the path to the Firebase sources based on the given [tempDir].
  static String firebase(String tempDir) => '$tempDir/metrics/firebase';

  /// Returns the path to the Firebase functions sources based on
  /// the given [tempDir].
  static String firebaseFunctions(String tempDir) =>
      '${firebase(tempDir)}/functions';

  /// Returns the path to the Metrics configuration file based on
  /// the given [tempDir].
  static String metricsConfig(String tempDir) =>
      '${web(tempDir)}/build/web/metrics_config.js';
}

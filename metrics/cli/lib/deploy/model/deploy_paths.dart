// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that holds deploy paths based on the current root
/// directory path.
class DeployPaths {
  /// A path to the root directory.
  final String rootPath;

  /// Creates a new instance of the [DeployPaths] with
  /// the given [rootPath].
  ///
  /// Throws an [ArgumentError] if the given [rootPath] is `null`.
  DeployPaths(this.rootPath) {
    ArgumentError.checkNotNull(rootPath, 'rootPath');
  }

  /// A path to the Mertrics Web project sources.
  String get webAppPath => '$rootPath/metrics/web';

  /// A path to the built directory of the Metrics Web project.
  String get webAppBuildPath => '$rootPath/build/web';

  /// A path to the Firebase sources.
  String get firebasePath => '$rootPath/metrics/firebase';

  /// A path to the Firebase functions sources.
  String get firebaseFunctionsPath => '$firebasePath/functions';

  /// A path to the Metrics configuration file.
  String get metricsConfigPath => '$webAppPath/build/web/metrics_config.js';
}

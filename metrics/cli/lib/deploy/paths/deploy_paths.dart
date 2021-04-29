// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that holds deploy paths based on the current temporary
/// directory path.
class DeployPaths {
  /// The path to the current temporary directory;
  String _currentTempDirectoryPath;

  /// Initializes this temporary directory path with the given [path].
  ///
  /// Throws an [ArgumentError] if the given [path] is `null`.
  void initTempDirectoryPath(String path) {
    ArgumentError.checkNotNull(path, 'path');

    _currentTempDirectoryPath = path;
  }

  /// A path to the Web project sources.
  String get web => '$_currentTempDirectoryPath/metrics/web';

  /// A path to the built directory of the Metrics Web project.
  String get buildWeb => '$_currentTempDirectoryPath/build/web';

  /// A path to the Firebase sources.
  String get firebase => '$_currentTempDirectoryPath/metrics/firebase';

  /// A path to the Firebase functions sources.
  String get firebaseFunctions => '$firebase/functions';

  /// A path to the Metrics configuration file.
  String get metricsConfig => '$web/build/web/metrics_config.js';
}

/// Holds the strings for the Metrics CLI configuration.
class ConfigConstants {
  /// A URL to the Metrics repository.
  static const String repoURL = 'git@github.com:platform-platform/monorepo.git';

  /// A name of a temporary directory.
  static const String tempDir = 'tempDir';

  /// A path to the Web project sources.
  static const String webPath = '$tempDir/metrics/web';

  /// A path to the firebase sources.
  static const String firebasePath = '$tempDir/metrics/firebase';

  /// A path to the firebase functions sources.
  static const String firebaseFunctionsPath = '$firebasePath/functions';
}

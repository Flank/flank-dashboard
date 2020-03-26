/// An abstract class representing configurations for a project within
/// CI and builds storage context.
abstract class CiConfig {
  /// Used to identify a project in CI it belongs to.
  String get ciProjectId;

  /// Used to identify a project in a builds storage.
  String get storageProjectId;
}

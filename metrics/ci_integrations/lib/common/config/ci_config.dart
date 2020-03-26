/// An abstract class representing configurations for a project within
/// CI and Firestore context.
abstract class CiConfig {
  /// Used to identify a project in CI it belongs to.
  String get ciProjectIdentifier;

  /// Used to identify a project in Firestore database.
  String get firestoreProjectIdentifier;
}

import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides a firestore error description based
/// on [PersistentStoreErrorCode].
class ProjectGroupFirestoreErrorMessage {
  final PersistentStoreErrorCode _code;

  /// Provides the firestore error message based on the [PersistentStoreErrorCode].
  String get message {
    switch (_code) {
      case PersistentStoreErrorCode.unknown:
        return ProjectGroupsStrings.unknownErrorMessage;
      default:
        return null;
    }
  }

  /// Creates the [ProjectGroupFirestoreErrorMessage] from
  /// the given [PersistentStoreErrorCode].
  const ProjectGroupFirestoreErrorMessage(this._code);
}

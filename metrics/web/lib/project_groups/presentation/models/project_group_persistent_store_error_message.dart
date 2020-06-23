import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides a persistent store error description based
/// on the [PersistentStoreErrorCode].
class ProjectGroupPersistentStoreErrorMessage {
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

  /// Creates the [ProjectGroupPersistentStoreErrorMessage] with
  /// the given [PersistentStoreErrorCode].
  const ProjectGroupPersistentStoreErrorMessage(this._code);
}

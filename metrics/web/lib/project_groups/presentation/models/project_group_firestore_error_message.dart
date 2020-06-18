import 'package:metrics/common/domain/entities/firestore_error_code.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides a firestore error description based
/// on [FirestoreErrorCode].
class ProjectGroupFirestoreErrorMessage {
  final FirestoreErrorCode _code;

  /// Provides the firestore error message based on the [FirestoreErrorCode].
  String get message {
    switch (_code) {
      case FirestoreErrorCode.unknown:
        return ProjectGroupsStrings.unknownErrorMessage;
      default:
        return null;
    }
  }

  /// Creates the [ProjectGroupFirestoreErrorMessage] from
  /// the given [FirestoreErrorCode].
  const ProjectGroupFirestoreErrorMessage(this._code);
}

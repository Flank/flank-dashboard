import 'package:meta/meta.dart';

/// Represents the project group saving exception.
@immutable
class ProjectGroupSavingException implements Exception {
  final String message;

  /// Creates the [ProjectGroupSavingException] with the given [message].
  /// [message] is the text description of this exception.
  const ProjectGroupSavingException(this.message);
}

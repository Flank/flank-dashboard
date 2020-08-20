import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_error_code.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a project group project ids validation exception.
class ProjectGroupProjectIdsValidationException
    extends ValidationException<ProjectGroupProjectIdsValidationErrorCode> {
  @override
  final ProjectGroupProjectIdsValidationErrorCode code;

  /// Creates the [ProjectGroupProjectIdsValidationException] with the given [code].
  ///
  /// Throws an [ArgumentError] if the [code] is null.
  ProjectGroupProjectIdsValidationException(this.code);
}

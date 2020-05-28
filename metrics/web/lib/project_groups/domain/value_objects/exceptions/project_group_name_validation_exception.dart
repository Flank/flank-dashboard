// ignore_for_file: implementation_imports

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics_core/src/domain/value_objects/exceptions/validation_exception.dart';

/// Represents the project group name validation exception.
class ProjectGroupNameValidationException
    extends ValidationException<ProjectGroupNameValidationErrorCode> {
  @override
  final ProjectGroupNameValidationErrorCode code;


  /// Creates the [ProjectGroupNameValidationException] with the given [code].
  ///
  /// [code] is the code of this error that specifies the concrete reason for the exception occurrence.
  /// Throws an [ArgumentError] if the [code] is null.
  ProjectGroupNameValidationException(this.code);
}

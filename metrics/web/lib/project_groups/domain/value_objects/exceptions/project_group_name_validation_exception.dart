// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a project group name validation exception.
class ProjectGroupNameValidationException
    extends ValidationException<ProjectGroupNameValidationErrorCode> {
  @override
  final ProjectGroupNameValidationErrorCode code;

  /// Creates the [ProjectGroupNameValidationException] with the given [code].
  ///
  /// Throws an [ArgumentError] if the [code] is null.
  ProjectGroupNameValidationException(this.code);
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_error_code.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a project group's projects validation exception.
class ProjectGroupProjectsValidationException
    extends ValidationException<ProjectGroupProjectsValidationErrorCode> {
  @override
  final ProjectGroupProjectsValidationErrorCode code;

  /// Creates the [ProjectGroupProjectsValidationException] with the given [code].
  ///
  /// Throws an [ArgumentError] if the [code] is null.
  ProjectGroupProjectsValidationException(this.code);
}

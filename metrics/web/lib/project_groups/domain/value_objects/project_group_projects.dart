// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] for a project group projects.
class ProjectGroupProjects extends ValueObject<List<String>> {
  /// A maximum number of projects in the project group.
  static const maxNumberOfProjects = 20;

  @override
  final List<String> value;

  /// Creates the [ProjectGroupProjects] with the given [value].
  ///
  /// If the [value] exceeds the [maxNumberOfProjects], throws
  /// a [ProjectGroupProjectsValidationException].
  ProjectGroupProjects(this.value) {
    if (value.length > maxNumberOfProjects) {
      throw ProjectGroupProjectsValidationException(
        ProjectGroupProjectsValidationErrorCode.maxProjectsLimitExceeded,
      );
    }
  }
}

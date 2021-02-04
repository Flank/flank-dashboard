// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] for a project group name.
class ProjectGroupName extends ValueObject<String> {
  /// A project group name characters limit.
  static const charactersLimit = 255;

  @override
  final String value;

  /// Creates the [ProjectGroupName] with the given [value].
  ///
  /// If the [value] is `null`, empty, or exceeds the [charactersLimit], throws
  /// a [ProjectGroupNameValidationException].
  ProjectGroupName(this.value) {
    if (value == null || value.trim().isEmpty) {
      throw ProjectGroupNameValidationException(
        ProjectGroupNameValidationErrorCode.isNull,
      );
    } else if (value.length > charactersLimit) {
      throw ProjectGroupNameValidationException(
        ProjectGroupNameValidationErrorCode.charactersLimitExceeded,
      );
    }
  }
}

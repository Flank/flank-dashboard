import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] represents a password.
class ProjectGroupName extends ValueObject<String> {
  @override
  final String value;

  /// Creates the [ProjectGroupName] with the given [value].
  ///
  /// If [value] is null or empty throws a [ProjectGroupNameValidationException].
  ProjectGroupName(this.value) {
    if (value == null || value.isEmpty) {
      throw ProjectGroupNameValidationException(
        ProjectGroupNameValidationErrorCode.isNull,
      );
    }
  }
}

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] for a project group project ids.
class ProjectGroupProjectIds extends ValueObject<List<String>> {
  /// A project ids selection size limit.
  static const projectIdsSelectionSizeLimit = 20;

  @override
  final List<String> value;

  /// Creates the [ProjectGroupProjectIds] with the given [value].
  ///
  /// If the [value] exceeds the [projectIdsSelectionSizeLimit], throws
  /// a [ProjectGroupProjectIdsValidationException].
  ProjectGroupProjectIds(this.value) {
    if (value.length > projectIdsSelectionSizeLimit) {
      throw ProjectGroupProjectIdsValidationException(
        ProjectGroupProjectIdsValidationErrorCode
            .projectsSelectionLimitExceeded,
      );
    }
  }
}

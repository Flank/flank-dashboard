import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/util/model/pagination.dart';
import 'package:meta/meta.dart';

/// A class that represents a page of [WorkflowRunArtifact]
class WorkflowRunArtifactsPagination extends Pagination<WorkflowRunArtifact> {
  /// Creates a new instance of the [WorkflowRunArtifactsPagination].
  const WorkflowRunArtifactsPagination({
    int totalCount,
    int page,
    int pageCount,
    List<WorkflowRunArtifact> values,
  }) : super(
          totalCount: totalCount,
          page: page,
          pageCount: pageCount,
          values: values,
        );

  /// Creates a new instance of the [WorkflowRunArtifactsPagination] from the
  /// decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  /// Returns an empty [WorkflowRunArtifactsPagination] if the given [perPage]
  /// equals to `0`.
  ///
  /// If the given [perPage] is `null`, throws [ArgumentError].
  factory WorkflowRunArtifactsPagination.fromJson(
    Map<String, dynamic> json, {
    @required int page,
  }) {
    if (json == null) return null;

    final totalCount = json['total_count'] as int;

    final runsArtifactsList = json['artifacts'] as List<dynamic>;
    final artifacts = WorkflowRunArtifact.listFromJson(runsArtifactsList);

    final pageCount = (totalCount / artifacts?.length ?? 1).ceil();

    return WorkflowRunArtifactsPagination(
      totalCount: totalCount,
      page: page,
      pageCount: pageCount,
      values: artifacts,
    );
  }
}

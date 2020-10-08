import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/util/model/pagination.dart';
import 'package:meta/meta.dart';

/// A class that represents a page of [WorkflowRun]s.
class WorkflowRunsPagination extends Pagination<WorkflowRun> {
  /// Creates a new instance of the [WorkflowRunsPagination].
  const WorkflowRunsPagination({
    int totalCount,
    int page,
    int pageCount,
    List<WorkflowRun> values,
  }) : super(
          totalCount: totalCount,
          page: page,
          pageCount: pageCount,
          values: values,
        );

  /// Creates a new instance of the [WorkflowRunsPagination] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  /// Returns an empty [WorkflowRunsPagination] if the given [perPage]
  /// equals to `0`.
  ///
  /// If the given [perPage] is `null`, throws [ArgumentError].
  factory WorkflowRunsPagination.fromJson(
    Map<String, dynamic> json, {
    @required int page,
    @required int perPage,
  }) {
    if (json == null) return null;

    ArgumentError.checkNotNull(perPage);

    if (perPage == 0) {
      return const WorkflowRunsPagination(
        totalCount: 0,
        page: 0,
        pageCount: 0,
        values: [],
      );
    }

    final totalCount = json['total_count'] as int;

    final runsList = json['workflow_runs'] as List<dynamic>;
    final runs = WorkflowRun.listFromJson(runsList);

    final pageCount = (totalCount / runs?.length ?? 1).ceil();

    return WorkflowRunsPagination(
      totalCount: totalCount,
      page: page,
      pageCount: pageCount,
      values: WorkflowRun.listFromJson(runsList),
    );
  }
}

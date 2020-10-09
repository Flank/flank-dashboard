import 'package:ci_integration/client/github_actions/models/page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';

/// A class that represents a page of [WorkflowRun]s that is used to paginate
/// the workflow runs fetching.
class WorkflowRunsPage extends Page<WorkflowRun> {
  /// Creates a new instance of the [WorkflowRunsPage].
  const WorkflowRunsPage({
    int totalCount,
    int page,
    int perPage,
    String nextPageUrl,
    List<WorkflowRun> values,
  }) : super(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );
}

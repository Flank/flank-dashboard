import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';

/// A class that represents a page of [WorkflowRunJob] that is used to
/// paginate the run jobs fetching.
class WorkflowRunJobsPage extends Page<WorkflowRunJob> {
  /// Creates a new instance of the [WorkflowRunJobsPage].
  const WorkflowRunJobsPage({
    int totalCount,
    int page,
    int perPage,
    String nextPageUrl,
    List<WorkflowRunJob> values,
  }) : super(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );
}

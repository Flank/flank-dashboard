import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/util/model/page.dart';

/// A class that represents a page of [WorkflowRunArtifact]
class WorkflowRunArtifactsPage extends Page<WorkflowRunArtifact> {
  /// Creates a new instance of the [WorkflowRunArtifactsPage].
  const WorkflowRunArtifactsPage({
    int totalCount,
    int page,
    int perPage,
    String nextPageUrl,
    List<WorkflowRunArtifact> values,
  }) : super(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );
}

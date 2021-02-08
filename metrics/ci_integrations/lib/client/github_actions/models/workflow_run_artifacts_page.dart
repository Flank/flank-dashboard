// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';

/// A class that represents a page of [WorkflowRunArtifact] that is used to
/// paginate the run artifacts fetching.
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

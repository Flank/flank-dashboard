// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';

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

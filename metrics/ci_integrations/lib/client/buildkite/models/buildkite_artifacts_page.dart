// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';

/// A class that represents a page of [BuildkiteArtifact]s that is used to
/// paginate the build's artifacts fetching.
class BuildkiteArtifactsPage extends Page<BuildkiteArtifact> {
  /// Creates a new instance of the [BuildkiteArtifactsPage].
  const BuildkiteArtifactsPage({
    int page,
    int perPage,
    String nextPageUrl,
    List<BuildkiteArtifact> values,
  }) : super(
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );
}

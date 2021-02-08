// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';

/// A class that represents a page of [BuildkiteBuild]s that is used to paginate
/// the builds fetching.
class BuildkiteBuildsPage extends Page<BuildkiteBuild> {
  /// Creates a new instance of the [BuildkiteBuild].
  const BuildkiteBuildsPage({
    int page,
    int perPage,
    String nextPageUrl,
    List<BuildkiteBuild> values,
  }) : super(
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );
}

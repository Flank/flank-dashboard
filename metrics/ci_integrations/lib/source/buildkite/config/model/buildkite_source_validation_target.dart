// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [BuildkiteSourceConfig]'s fields.
class BuildkiteSourceValidationTarget {
  /// An access token field of the [BuildkiteSourceConfig].
  static const accessToken = ValidationTarget(name: 'access_token');

  /// An organization slug field of the [BuildkiteSourceConfig].
  static const organizationSlug = ValidationTarget(name: 'organization_slug');

  /// A source project ID field of the [BuildkiteSourceConfig].
  static const pipelineSlug = ValidationTarget(name: 'pipeline_slug');

  /// A list containing all [BuildkiteSourceValidationTarget]s of
  /// the [BuildkiteSourceConfig].
  static final List<ValidationTarget> values = UnmodifiableListView([
    accessToken,
    organizationSlug,
    pipelineSlug,
  ]);
}

// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/integration/interface/base/config/model/config_field.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';

/// A class that represents the [BuildkiteSourceConfig]'s fields.
class BuildkiteSourceConfigField extends ConfigField {
  /// An access token field of the [BuildkiteSourceConfig].
  static final BuildkiteSourceConfigField accessToken =
      BuildkiteSourceConfigField._('access_token');

  /// An organization slug field of the [BuildkiteSourceConfig].
  static final BuildkiteSourceConfigField organizationSlug =
      BuildkiteSourceConfigField._('organization_slug');

  /// A source project ID field of the [BuildkiteSourceConfig].
  static final BuildkiteSourceConfigField pipelineSlug =
      BuildkiteSourceConfigField._('pipeline_slug');

  /// A list containing all [BuildkiteSourceConfigField]s of
  /// the [BuildkiteSourceConfig].
  static final List<BuildkiteSourceConfigField> values = UnmodifiableListView([
    accessToken,
    organizationSlug,
    pipelineSlug,
  ]);

  /// Creates an instance of the [BuildkiteSourceConfigField] with the
  /// given value.
  ///
  /// Throws an [ArgumentError] if the given [value] is `null`.
  BuildkiteSourceConfigField._(
    String value,
  ) : super(value);
}

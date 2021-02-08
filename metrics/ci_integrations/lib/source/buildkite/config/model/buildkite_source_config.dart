// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a [SourceConfig] for the Buildkite integration.
class BuildkiteSourceConfig extends Equatable implements SourceConfig {
  /// A Buildkite access token.
  final String accessToken;

  /// A unique slug (identifier) of the pipeline on Buildkite the integration
  /// should work with.
  final String pipelineSlug;

  /// A unique slug (identifier) of the organization on Buildkite in the scope
  /// of which the integration should work and perform requests.
  final String organizationSlug;

  @override
  String get sourceProjectId => pipelineSlug;

  @override
  List<Object> get props => [
        accessToken,
        pipelineSlug,
        organizationSlug,
      ];

  /// Creates a new instance of the [BuildkiteSourceConfig].
  ///
  /// Throws an [ArgumentError] if any of the required parameters
  /// is `null` or empty.
  BuildkiteSourceConfig({
    @required this.accessToken,
    @required this.pipelineSlug,
    @required this.organizationSlug,
  }) {
    StringValidator.checkNotNullOrEmpty(
      accessToken,
      name: 'accessToken',
    );
    StringValidator.checkNotNullOrEmpty(
      pipelineSlug,
      name: 'pipelineSlug',
    );
    StringValidator.checkNotNullOrEmpty(
      organizationSlug,
      name: 'organizationSlug',
    );
  }

  /// Creates a new instance of the [BuildkiteSourceConfig] from the
  /// decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteSourceConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return BuildkiteSourceConfig(
      accessToken: json['access_token'] as String,
      pipelineSlug: json['pipeline_slug'] as String,
      organizationSlug: json['organization_slug'] as String,
    );
  }
}

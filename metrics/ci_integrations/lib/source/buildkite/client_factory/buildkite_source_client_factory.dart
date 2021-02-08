// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/integration/interface/source/client_factory/source_client_factory.dart';
import 'package:ci_integration/source/buildkite/adapter/buildkite_source_client_adapter.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A client factory for Buildkite source integration.
///
/// Used to create instances of the [BuildkiteSourceClientAdapter]
/// using [BuildkiteSourceConfig].
class BuildkiteSourceClientFactory
    implements
        SourceClientFactory<BuildkiteSourceConfig,
            BuildkiteSourceClientAdapter> {
  /// Creates a new instance of the [BuildkiteSourceClientFactory].
  const BuildkiteSourceClientFactory();

  @override
  BuildkiteSourceClientAdapter create(BuildkiteSourceConfig config) {
    ArgumentError.checkNotNull(config, 'config');

    final authorization = BearerAuthorization(config.accessToken);
    final buildkiteClient = BuildkiteClient(
      organizationSlug: config.organizationSlug,
      authorization: authorization,
    );
    final buildkiteSourceClientAdapter = BuildkiteSourceClientAdapter(
      buildkiteClient: buildkiteClient,
    );

    return buildkiteSourceClientAdapter;
  }
}

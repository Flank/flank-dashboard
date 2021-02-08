// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/config/parser/source_config_parser.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';

/// A configuration parser for the Buildkite source integration.
class BuildkiteSourceConfigParser
    implements SourceConfigParser<BuildkiteSourceConfig> {
  /// Creates a new instance of the [BuildkiteSourceConfigParser].
  const BuildkiteSourceConfigParser();

  @override
  bool canParse(Map<String, dynamic> map) {
    return map != null && map['buildkite'] != null;
  }

  @override
  BuildkiteSourceConfig parse(Map<String, dynamic> map) {
    if (map == null) return null;

    final configMap = map['buildkite'] as Map<String, dynamic>;

    return BuildkiteSourceConfig.fromJson(configMap);
  }
}

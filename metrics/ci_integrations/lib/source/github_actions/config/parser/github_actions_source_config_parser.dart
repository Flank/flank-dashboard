// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/config/parser/source_config_parser.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';

/// A configuration parser for the Github Actions source integration.
class GithubActionsSourceConfigParser
    implements SourceConfigParser<GithubActionsSourceConfig> {
  /// Creates a new instance of the [GithubActionsSourceConfigParser].
  const GithubActionsSourceConfigParser();

  @override
  bool canParse(Map<String, dynamic> map) {
    return map != null && map['github_actions'] != null;
  }

  @override
  GithubActionsSourceConfig parse(Map<String, dynamic> map) {
    if (map == null) return null;

    final configMap = map['github_actions'] as Map<String, dynamic>;
    return GithubActionsSourceConfig.fromJson(configMap);
  }
}

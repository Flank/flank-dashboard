// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/party/source_party.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_client_adapter.dart';
import 'package:ci_integration/source/github_actions/client_factory/github_actions_source_client_factory.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/source/github_actions/config/parser/github_actions_source_config_parser.dart';

/// An integration party for the Github Actions source integration.
class GithubActionsSourceParty
    implements
        SourceParty<GithubActionsSourceConfig,
            GithubActionsSourceClientAdapter> {
  @override
  final GithubActionsSourceClientFactory clientFactory =
      const GithubActionsSourceClientFactory();

  @override
  final GithubActionsSourceConfigParser configParser =
      const GithubActionsSourceConfigParser();
}

// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';

/// An enum that represents a scope of the [BuildkiteToken].
enum BuildkiteTokenScope {
  /// A token scope that allows to list and retrieve agent details.
  readAgents,

  /// A token scope that allows to create, update and delete agents.
  writeAgents,

  /// A token scope that allows to list teams.
  readTeams,

  /// A token scope that allows to retrieve build artifacts.
  readArtifacts,

  /// A token scope that allows to delete build artifacts.
  writeArtifacts,

  /// A token scope that allows to list and retrieve build details.
  readBuilds,

  /// A token scope that allows to create new builds.
  writeBuilds,

  /// A token scope that allows to retrieve job environment variables.
  readJobEnvironment,

  /// A token scope that allows to retrieve build logs.
  readBuildLogs,

  /// A token scope that allows to delete build logs.
  writeBuildLogs,

  /// A token scope that allows to list and retrieve organization details.
  readOrganizations,

  /// A token scope that allows to list and retrieve pipeline details.
  readPipelines,

  /// A token scope that allows to create, update and delete pipelines.
  writePipelines,

  /// A token scope that allows to retrieve basic user details.
  readUser,
}

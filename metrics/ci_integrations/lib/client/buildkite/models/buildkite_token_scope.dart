import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';

/// An [Enum] that contains all scopes for a [BuildkiteToken].
enum BuildkiteTokenScope {
  /// A token scope that allows to list and retrieve details of agents.
  readAgents,

  /// A token scope that allows to create, update and delete agents.
  writeAgents,

  /// A token scope that allows to list teams.
  readTeams,

  /// A token scope that allows to retrieve build artifacts.
  readArtifacts,

  /// A token scope that allows to delete build artifacts.
  writeArtifacts,

  /// A token scope that allows to list and retrieve details of builds.
  readBuilds,

  /// A token scope that allows to create new builds.
  writeBuilds,

  /// A token scope that allows to retrieve job environment variables.
  readJobEnvironment,

  /// A token scope that allows to retrieve build logs.
  readBuildLogs,

  /// A token scope that allows to delete build logs.
  writeBuildLogs,

  /// A token scope that allows to list and retrieve details of organizations.
  readOrganizations,

  /// A token scope that allows to list and retrieve details of pipelines.
  readPipelines,

  /// A token scope that allows to create, update and delete pipelines.
  writePipelines,

  /// A token scope that allows to retrieve basic details of the user.
  readUser,
}

import 'package:ci_integration/client/buildkite/models/buildkite_access_token.dart';

/// Represents permissions for a [BuildkiteAccessToken].
enum BuildkiteTokenPermission {
  /// A permission to list and retrieve details of agents.
  readAgents,

  /// A permission to create, update and delete agents.
  writeAgents,

  /// A permission to list teams.
  readTeams,

  /// A permission to retrieve build artifacts.
  readArtifacts,

  /// A permission to delete build artifacts.
  writeArtifacts,

  /// A permission to list and retrieve details of builds.
  readBuilds,

  /// A permission to create new builds.
  writeBuilds,

  /// A permission to retrieve job environment variables.
  readJobEnvironment,

  /// A permission to retrieve build logs.
  readBuildLogs,

  /// A permission to delete build logs.
  writeBuildLogs,

  /// A permission to list and retrieve details of organizations.
  readOrganizations,

  /// A permission to list and retrieve details of pipelines.
  readPipelines,

  /// A permission to create, update and delete pipelines.
  writePipelines,

  /// A permission to retrieve basic details of the user.
  readUser,
}

import 'package:ci_integration/client/buildkite/models/buildkite_token_permission.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Buildkite token permissions.
class BuildkiteTokenPermissionMapper
    implements Mapper<String, BuildkiteTokenPermission> {
  /// A permission to list and retrieve details of agents.
  static const String readAgents = 'read_agents';

  /// A permission to create, update and delete agents.
  static const String writeAgents = 'write_agents';

  /// A permission to list teams.
  static const String readTeams = 'read_teams';

  /// A permission to retrieve build artifacts.
  static const String readArtifacts = 'read_artifacts';

  /// A permission to delete build artifacts.
  static const String writeArtifacts = 'write_artifacts';

  /// A permission to list and retrieve details of builds.
  static const String readBuilds = 'read_builds';

  /// A permission to create new builds.
  static const String writeBuilds = 'write_builds';

  /// A permission to retrieve job environment variables.
  static const String readJobEnvironment = 'read_job_env';

  /// A permission to retrieve build logs.
  static const String readBuildLogs = 'read_build_logs';

  /// A permission to delete build logs.
  static const String writeBuildLogs = 'write_build_logs';

  /// A permission to list and retrieve details of organizations.
  static const String readOrganizations = 'read_organizations';

  /// A permission to list and retrieve details of pipelines.
  static const String readPipelines = 'read_pipelines';

  /// A permission to create, update and delete pipelines.
  static const String writePipelines = 'write_pipelines';

  /// A permission to retrieve basic details of the user.
  static const String readUser = 'read_user';

  /// Creates a new instance of the [BuildkiteTokenPermissionMapper].
  const BuildkiteTokenPermissionMapper();

  @override
  BuildkiteTokenPermission map(String value) {
    switch (value) {
      case readAgents:
        return BuildkiteTokenPermission.readAgents;
      case writeAgents:
        return BuildkiteTokenPermission.writeAgents;
      case readTeams:
        return BuildkiteTokenPermission.readTeams;
      case readArtifacts:
        return BuildkiteTokenPermission.readArtifacts;
      case writeArtifacts:
        return BuildkiteTokenPermission.writeArtifacts;
      case readBuilds:
        return BuildkiteTokenPermission.readBuilds;
      case writeBuilds:
        return BuildkiteTokenPermission.writeBuilds;
      case readJobEnvironment:
        return BuildkiteTokenPermission.readJobEnvironment;
      case readBuildLogs:
        return BuildkiteTokenPermission.readBuildLogs;
      case writeBuildLogs:
        return BuildkiteTokenPermission.writeBuildLogs;
      case readOrganizations:
        return BuildkiteTokenPermission.readOrganizations;
      case readPipelines:
        return BuildkiteTokenPermission.readPipelines;
      case writePipelines:
        return BuildkiteTokenPermission.writePipelines;
      case readUser:
        return BuildkiteTokenPermission.readUser;
      default:
        return null;
    }
  }

  @override
  String unmap(BuildkiteTokenPermission value) {
    switch (value) {
      case BuildkiteTokenPermission.readAgents:
        return readAgents;
      case BuildkiteTokenPermission.writeAgents:
        return writeAgents;
      case BuildkiteTokenPermission.readTeams:
        return readTeams;
      case BuildkiteTokenPermission.readArtifacts:
        return readArtifacts;
      case BuildkiteTokenPermission.writeArtifacts:
        return writeArtifacts;
      case BuildkiteTokenPermission.readBuilds:
        return readBuilds;
      case BuildkiteTokenPermission.writeBuilds:
        return writeBuilds;
      case BuildkiteTokenPermission.readJobEnvironment:
        return readJobEnvironment;
      case BuildkiteTokenPermission.readBuildLogs:
        return readBuildLogs;
      case BuildkiteTokenPermission.writeBuildLogs:
        return writeBuildLogs;
      case BuildkiteTokenPermission.readOrganizations:
        return readOrganizations;
      case BuildkiteTokenPermission.readPipelines:
        return readPipelines;
      case BuildkiteTokenPermission.writePipelines:
        return writePipelines;
      case BuildkiteTokenPermission.readUser:
        return readUser;
      default:
        return null;
    }
  }
}

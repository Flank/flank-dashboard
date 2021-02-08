// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Buildkite token scopes.
class BuildkiteTokenScopeMapper implements Mapper<String, BuildkiteTokenScope> {
  /// A token scope that allows to list and retrieve agent details.
  static const String readAgents = 'read_agents';

  /// A token scope that allows to create, update and delete agents.
  static const String writeAgents = 'write_agents';

  /// A token scope that allows to list teams.
  static const String readTeams = 'read_teams';

  /// A token scope that allows to retrieve build artifacts.
  static const String readArtifacts = 'read_artifacts';

  /// A token scope that allows to delete build artifacts.
  static const String writeArtifacts = 'write_artifacts';

  /// A token scope that allows to list and retrieve build details.
  static const String readBuilds = 'read_builds';

  /// A token scope that allows to create new builds.
  static const String writeBuilds = 'write_builds';

  /// A token scope that allows to retrieve job environment variables.
  static const String readJobEnvironment = 'read_job_env';

  /// A token scope that allows to retrieve build logs.
  static const String readBuildLogs = 'read_build_logs';

  /// A token scope that allows to delete build logs.
  static const String writeBuildLogs = 'write_build_logs';

  /// A token scope that allows to list and retrieve organization details.
  static const String readOrganizations = 'read_organizations';

  /// A token scope that allows to list and retrieve pipeline details.
  static const String readPipelines = 'read_pipelines';

  /// A token scope that allows to create, update and delete pipelines.
  static const String writePipelines = 'write_pipelines';

  /// A token scope that allows to retrieve basic user details.
  static const String readUser = 'read_user';

  /// Creates a new instance of the [BuildkiteTokenScopeMapper].
  const BuildkiteTokenScopeMapper();

  @override
  BuildkiteTokenScope map(String value) {
    switch (value) {
      case readAgents:
        return BuildkiteTokenScope.readAgents;
      case writeAgents:
        return BuildkiteTokenScope.writeAgents;
      case readTeams:
        return BuildkiteTokenScope.readTeams;
      case readArtifacts:
        return BuildkiteTokenScope.readArtifacts;
      case writeArtifacts:
        return BuildkiteTokenScope.writeArtifacts;
      case readBuilds:
        return BuildkiteTokenScope.readBuilds;
      case writeBuilds:
        return BuildkiteTokenScope.writeBuilds;
      case readJobEnvironment:
        return BuildkiteTokenScope.readJobEnvironment;
      case readBuildLogs:
        return BuildkiteTokenScope.readBuildLogs;
      case writeBuildLogs:
        return BuildkiteTokenScope.writeBuildLogs;
      case readOrganizations:
        return BuildkiteTokenScope.readOrganizations;
      case readPipelines:
        return BuildkiteTokenScope.readPipelines;
      case writePipelines:
        return BuildkiteTokenScope.writePipelines;
      case readUser:
        return BuildkiteTokenScope.readUser;
      default:
        return null;
    }
  }

  @override
  String unmap(BuildkiteTokenScope value) {
    switch (value) {
      case BuildkiteTokenScope.readAgents:
        return readAgents;
      case BuildkiteTokenScope.writeAgents:
        return writeAgents;
      case BuildkiteTokenScope.readTeams:
        return readTeams;
      case BuildkiteTokenScope.readArtifacts:
        return readArtifacts;
      case BuildkiteTokenScope.writeArtifacts:
        return writeArtifacts;
      case BuildkiteTokenScope.readBuilds:
        return readBuilds;
      case BuildkiteTokenScope.writeBuilds:
        return writeBuilds;
      case BuildkiteTokenScope.readJobEnvironment:
        return readJobEnvironment;
      case BuildkiteTokenScope.readBuildLogs:
        return readBuildLogs;
      case BuildkiteTokenScope.writeBuildLogs:
        return writeBuildLogs;
      case BuildkiteTokenScope.readOrganizations:
        return readOrganizations;
      case BuildkiteTokenScope.readPipelines:
        return readPipelines;
      case BuildkiteTokenScope.writePipelines:
        return writePipelines;
      case BuildkiteTokenScope.readUser:
        return readUser;
      default:
        return null;
    }
  }
}

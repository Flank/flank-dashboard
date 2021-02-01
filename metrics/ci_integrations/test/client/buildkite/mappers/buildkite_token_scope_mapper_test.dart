import 'package:ci_integration/client/buildkite/mappers/buildkite_token_scope_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteTokenScopeMapper", () {
    const mapper = BuildkiteTokenScopeMapper();

    test(
      ".map() maps the read agents scope to the BuildkiteTokenScope.readAgents",
      () {
        const expectedScope = BuildkiteTokenScope.readAgents;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readAgents,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write agents scope to the BuildkiteTokenScope.writeAgents",
      () {
        const expectedScope = BuildkiteTokenScope.writeAgents;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.writeAgents,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read teams scope to the BuildkiteTokenScope.readTeams",
      () {
        const expectedScope = BuildkiteTokenScope.readTeams;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readTeams,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read artifacts scope to the BuildkiteTokenScope.readArtifacts",
      () {
        const expectedScope = BuildkiteTokenScope.readArtifacts;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readArtifacts,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write artifacts scope to the BuildkiteTokenScope.writeArtifacts",
      () {
        const expectedScope = BuildkiteTokenScope.writeArtifacts;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.writeArtifacts,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read builds scope to the BuildkiteTokenScope.readBuilds",
      () {
        const expectedScope = BuildkiteTokenScope.readBuilds;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readBuilds,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write builds scope to the BuildkiteTokenScope.writeBuilds",
      () {
        const expectedScope = BuildkiteTokenScope.writeBuilds;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.writeBuilds,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read job environment scope to the BuildkiteTokenScope.readJobEnvironment",
      () {
        const expectedScope = BuildkiteTokenScope.readJobEnvironment;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readJobEnvironment,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read build logs scope to the BuildkiteTokenScope.readBuildLogs",
      () {
        const expectedScope = BuildkiteTokenScope.readBuildLogs;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readBuildLogs,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write build logs scope to the BuildkiteTokenScope.writeBuildLogs",
      () {
        const expectedScope = BuildkiteTokenScope.writeBuildLogs;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.writeBuildLogs,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read organizations scope to the BuildkiteTokenScope.readOrganizations",
      () {
        const expectedScope = BuildkiteTokenScope.readOrganizations;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readOrganizations,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read pipelines scope to the BuildkiteTokenScope.readPipelines",
      () {
        const expectedScope = BuildkiteTokenScope.readPipelines;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readPipelines,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write pipelines scope to the BuildkiteTokenScope.writePipelines",
      () {
        const expectedScope = BuildkiteTokenScope.writePipelines;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.writePipelines,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read user scope to the BuildkiteTokenScope.readUser",
      () {
        const expectedScope = BuildkiteTokenScope.readUser;

        final scope = mapper.map(
          BuildkiteTokenScopeMapper.readUser,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the not existing scope to null",
      () {
        final scope = mapper.map('test');

        expect(scope, isNull);
      },
    );

    test(
      ".map() returns null if the given scope is null",
      () {
        final scope = mapper.map(null);

        expect(scope, isNull);
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readAgents to the read agents scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readAgents;

        final scope = mapper.unmap(BuildkiteTokenScope.readAgents);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.writeAgents to the write agents scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.writeAgents;

        final scope = mapper.unmap(BuildkiteTokenScope.writeAgents);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readTeams to the read teams scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readTeams;

        final scope = mapper.unmap(BuildkiteTokenScope.readTeams);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readArtifacts to the read artifacts scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readArtifacts;

        final scope = mapper.unmap(BuildkiteTokenScope.readArtifacts);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.writeArtifacts to the write artifacts scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.writeArtifacts;

        final scope = mapper.unmap(
          BuildkiteTokenScope.writeArtifacts,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readBuilds to the read builds scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readBuilds;

        final scope = mapper.unmap(BuildkiteTokenScope.readBuilds);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.writeBuilds to the write builds scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.writeBuilds;

        final scope = mapper.unmap(BuildkiteTokenScope.writeBuilds);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readJobEnvironment to the read job environment scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readJobEnvironment;

        final scope = mapper.unmap(
          BuildkiteTokenScope.readJobEnvironment,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readBuildLogs to the read build logs scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readBuildLogs;

        final scope = mapper.unmap(BuildkiteTokenScope.readBuildLogs);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.writeBuildLogs to the write build logs scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.writeBuildLogs;

        final scope = mapper.unmap(
          BuildkiteTokenScope.writeBuildLogs,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readOrganizations to the read organizations scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readOrganizations;

        final scope = mapper.unmap(
          BuildkiteTokenScope.readOrganizations,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readPipelines to the read pipelines scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readPipelines;

        final scope = mapper.unmap(BuildkiteTokenScope.readPipelines);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.writePipelines to the write pipelines scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.writePipelines;

        final scope = mapper.unmap(
          BuildkiteTokenScope.writePipelines,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenScope.readUser to the read user scope value",
      () {
        const expectedScope = BuildkiteTokenScopeMapper.readUser;

        final scope = mapper.unmap(BuildkiteTokenScope.readUser);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() returns null if the given scope is null",
      () {
        final scope = mapper.unmap(null);

        expect(scope, isNull);
      },
    );
  });
}

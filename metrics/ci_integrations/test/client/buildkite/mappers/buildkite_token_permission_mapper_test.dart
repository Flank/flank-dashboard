import 'package:ci_integration/client/buildkite/mappers/buildkite_token_permission_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_permission.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteTokenPermissionMapper", () {
    const mapper = BuildkiteTokenPermissionMapper();

    test(
      ".map() maps the read agents permission to the BuildkiteTokenPermission.readAgents",
      () {
        const expectedPermission = BuildkiteTokenPermission.readAgents;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readAgents,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the write agents permission to the BuildkiteTokenPermission.writeAgents",
      () {
        const expectedPermission = BuildkiteTokenPermission.writeAgents;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.writeAgents,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read teams permission to the BuildkiteTokenPermission.readTeams",
      () {
        const expectedPermission = BuildkiteTokenPermission.readTeams;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readTeams,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read artifacts permission to the BuildkiteTokenPermission.readArtifacts",
      () {
        const expectedPermission = BuildkiteTokenPermission.readArtifacts;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readArtifacts,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the write artifacts permission to the BuildkiteTokenPermission.writeArtifacts",
      () {
        const expectedPermission = BuildkiteTokenPermission.writeArtifacts;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.writeArtifacts,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read builds permission to the BuildkiteTokenPermission.readBuilds",
      () {
        const expectedPermission = BuildkiteTokenPermission.readBuilds;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readBuilds,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the write builds permission to the BuildkiteTokenPermission.writeBuilds",
      () {
        const expectedPermission = BuildkiteTokenPermission.writeBuilds;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.writeBuilds,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read job environment permission to the BuildkiteTokenPermission.readJobEnvironment",
      () {
        const expectedPermission = BuildkiteTokenPermission.readJobEnvironment;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readJobEnvironment,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read build logs permission to the BuildkiteTokenPermission.readBuildLogs",
      () {
        const expectedPermission = BuildkiteTokenPermission.readBuildLogs;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readBuildLogs,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the write build logs permission to the BuildkiteTokenPermission.writeBuildLogs",
      () {
        const expectedPermission = BuildkiteTokenPermission.writeBuildLogs;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.writeBuildLogs,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read organizations permission to the BuildkiteTokenPermission.readOrganizations",
      () {
        const expectedPermission = BuildkiteTokenPermission.readOrganizations;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readOrganizations,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read pipelines permission to the BuildkiteTokenPermission.readPipelines",
      () {
        const expectedPermission = BuildkiteTokenPermission.readPipelines;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readPipelines,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the write pipelines permission to the BuildkiteTokenPermission.writePipelines",
      () {
        const expectedPermission = BuildkiteTokenPermission.writePipelines;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.writePipelines,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the read user permission to the BuildkiteTokenPermission.readUser",
      () {
        const expectedPermission = BuildkiteTokenPermission.readUser;

        final permission = mapper.map(
          BuildkiteTokenPermissionMapper.readUser,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".map() maps the not specified permission to null",
      () {
        final permission = mapper.map('test');

        expect(permission, isNull);
      },
    );

    test(
      ".map() maps the null permission to null",
      () {
        final permission = mapper.map(null);

        expect(permission, isNull);
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readAgents to the read agents permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readAgents;

        final permission = mapper.unmap(BuildkiteTokenPermission.readAgents);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.writeAgents to the write agents permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.writeAgents;

        final permission = mapper.unmap(BuildkiteTokenPermission.writeAgents);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readTeams to the read teams permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readTeams;

        final permission = mapper.unmap(BuildkiteTokenPermission.readTeams);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readArtifacts to the read artifacts permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readArtifacts;

        final permission = mapper.unmap(BuildkiteTokenPermission.readArtifacts);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.writeArtifacts to the write artifacts permission value",
      () {
        const expectedPermission =
            BuildkiteTokenPermissionMapper.writeArtifacts;

        final permission = mapper.unmap(
          BuildkiteTokenPermission.writeArtifacts,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readBuilds to the read builds permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readBuilds;

        final permission = mapper.unmap(BuildkiteTokenPermission.readBuilds);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.writeBuilds to the write builds permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.writeBuilds;

        final permission = mapper.unmap(BuildkiteTokenPermission.writeBuilds);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readJobEnvironment to the read job environment permission value",
      () {
        const expectedPermission =
            BuildkiteTokenPermissionMapper.readJobEnvironment;

        final permission = mapper.unmap(
          BuildkiteTokenPermission.readJobEnvironment,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readBuildLogs to the read build logs permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readBuildLogs;

        final permission = mapper.unmap(BuildkiteTokenPermission.readBuildLogs);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.writeBuildLogs to the write build logs permission value",
      () {
        const expectedPermission =
            BuildkiteTokenPermissionMapper.writeBuildLogs;

        final permission = mapper.unmap(
          BuildkiteTokenPermission.writeBuildLogs,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readOrganizations to the read organizations permission value",
      () {
        const expectedPermission =
            BuildkiteTokenPermissionMapper.readOrganizations;

        final permission = mapper.unmap(
          BuildkiteTokenPermission.readOrganizations,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readPipelines to the read pipelines permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readPipelines;

        final permission = mapper.unmap(BuildkiteTokenPermission.readPipelines);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.writePipelines to the write pipelines permission value",
      () {
        const expectedPermission =
            BuildkiteTokenPermissionMapper.writePipelines;

        final permission = mapper.unmap(
          BuildkiteTokenPermission.writePipelines,
        );

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteTokenPermission.readUser to the read user permission value",
      () {
        const expectedPermission = BuildkiteTokenPermissionMapper.readUser;

        final permission = mapper.unmap(BuildkiteTokenPermission.readUser);

        expect(permission, equals(expectedPermission));
      },
    );

    test(
      ".unmap() unmaps null to null",
      () {
        final permission = mapper.unmap(null);

        expect(permission, isNull);
      },
    );
  });
}

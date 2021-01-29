import 'package:ci_integration/client/buildkite/mappers/buildkite_token_permission_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_permission.dart';
import 'package:test/test.dart';

void main() {
  const permissionStrings = [
    BuildkiteTokenPermissionMapper.readAgents,
    BuildkiteTokenPermissionMapper.writeAgents,
  ];

  const permissions = [
    BuildkiteTokenPermission.readAgents,
    BuildkiteTokenPermission.writeAgents,
  ];

  const tokenJson = {
    'scopes': permissionStrings,
  };

  const expectedToken = BuildkiteToken(
    permissions: permissions,
  );

  group("BuildkiteToken", () {
    test(
      "creates an instance with the given permissions",
      () {
        const token = BuildkiteToken(permissions: permissions);

        expect(token.permissions, equals(permissions));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final token = BuildkiteToken.fromJson(null);

        expect(token, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final token = BuildkiteToken.fromJson(tokenJson);

        expect(token, equals(expectedToken));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final list = BuildkiteToken.listFromJson(null);

        expect(list, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list to an empty one",
      () {
        final list = BuildkiteToken.listFromJson(
          [],
        );

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() map a list of buildkite tokens",
      () {
        const anotherJson = {'scopes': []};
        const anotherToken = BuildkiteToken(permissions: []);
        const jsonList = [tokenJson, anotherJson];
        const expectedList = [expectedToken, anotherToken];

        final tokenList = BuildkiteToken.listFromJson(jsonList);

        expect(tokenList, equals(expectedList));
      },
    );

    test(
      ".toJson converts an instance to the json encodable map",
      () {
        final json = expectedToken.toJson();

        expect(json, equals(tokenJson));
      },
    );
  });
}

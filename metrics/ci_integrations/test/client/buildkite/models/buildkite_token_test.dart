import 'package:ci_integration/client/buildkite/mappers/buildkite_token_scope_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:test/test.dart';

void main() {
  const scopeStrings = [
    BuildkiteTokenScopeMapper.readAgents,
    BuildkiteTokenScopeMapper.writeAgents,
  ];

  const scopes = [
    BuildkiteTokenScope.readAgents,
    BuildkiteTokenScope.writeAgents,
  ];

  const tokenJson = {
    'scopes': scopeStrings,
  };

  const expectedToken = BuildkiteToken(
    scopes: scopes,
  );

  group("BuildkiteToken", () {
    test(
      "creates an instance with the given scopes",
      () {
        const token = BuildkiteToken(scopes: scopes);

        expect(token.scopes, equals(scopes));
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
        const anotherToken = BuildkiteToken(scopes: []);
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

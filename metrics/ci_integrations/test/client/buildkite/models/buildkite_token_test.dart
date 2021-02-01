import 'package:ci_integration/client/buildkite/mappers/buildkite_token_scope_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteToken", () {
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

    const token = BuildkiteToken(
      scopes: scopes,
    );

    test(
      "creates an instance with the given parameters",
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
        final actualToken = BuildkiteToken.fromJson(tokenJson);

        expect(actualToken, equals(token));
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
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final list = BuildkiteToken.listFromJson([]);

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of Buildkite tokens from the given list of JSON encodable objects",
      () {
        const anotherJson = {'scopes': []};
        const anotherToken = BuildkiteToken(scopes: []);
        const jsonList = [tokenJson, anotherJson];
        const expectedList = [token, anotherToken];

        final tokenList = BuildkiteToken.listFromJson(jsonList);

        expect(tokenList, equals(expectedList));
      },
    );

    test(
      ".toJson converts an instance to the json encodable map",
      () {
        final json = token.toJson();

        expect(json, equals(tokenJson));
      },
    );
  });
}

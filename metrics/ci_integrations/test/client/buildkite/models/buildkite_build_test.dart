import 'package:ci_integration/client/buildkite/mappers/buildkite_build_state_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteBuild", () {
    const id = "1";
    const number = 1;
    const blocked = false;
    const state = BuildkiteBuildStateMapper.passed;
    const apiUrl = 'api-url';
    const webUrl = 'url';
    final startedAt = DateTime(2020).toUtc();
    final finishedAt = DateTime(2020, 2).toUtc();

    final buildJson = <String, dynamic>{
      'id': id,
      'number': number,
      'blocked': blocked,
      'url': apiUrl,
      'web_url': webUrl,
      'state': state,
      'started_at': startedAt?.toIso8601String(),
      'finished_at': finishedAt?.toIso8601String(),
    };

    final expectedBuild = BuildkiteBuild(
      id: id,
      number: number,
      blocked: blocked,
      state: BuildkiteBuildState.passed,
      apiUrl: apiUrl,
      webUrl: webUrl,
      startedAt: startedAt,
      finishedAt: finishedAt,
    );

    test("creates an instance with the given values", () {
      const state = BuildkiteBuildState.scheduled;

      final build = BuildkiteBuild(
        id: id,
        number: number,
        blocked: blocked,
        state: state,
        apiUrl: apiUrl,
        webUrl: webUrl,
        startedAt: startedAt,
        finishedAt: finishedAt,
      );

      expect(build.id, equals(id));
      expect(build.number, equals(number));
      expect(build.blocked, equals(blocked));
      expect(build.state, equals(state));
      expect(build.apiUrl, equals(apiUrl));
      expect(build.webUrl, equals(webUrl));
      expect(build.startedAt, equals(startedAt));
      expect(build.finishedAt, equals(finishedAt));
    });

    test(".fromJson() returns null if the given json is null", () {
      final build = BuildkiteBuild.fromJson(null);

      expect(build, isNull);
    });

    test(".fromJson() creates an instance from the given json", () {
      final build = BuildkiteBuild.fromJson(buildJson);

      expect(build, equals(expectedBuild));
    });

    test(".listFromJson() maps a null list to null", () {
      final builds = BuildkiteBuild.listFromJson(null);

      expect(builds, isNull);
    });

    test(".listFromJson() maps an empty list to empty one", () {
      final builds = BuildkiteBuild.listFromJson([]);

      expect(builds, isEmpty);
    });

    test(".listFromJson() maps a list of buildkite builds", () {
      final anotherJson = <String, dynamic>{
        'id': "2",
        'number': 2,
        'blocked': blocked,
        'web_url': 'url',
        'url': 'api-url',
        'state': BuildkiteBuildStateMapper.failed,
        'started_at': DateTime(2020, 3).toIso8601String(),
        'finished_at': DateTime(2020, 4).toIso8601String(),
      };
      final anotherBuild = BuildkiteBuild.fromJson(anotherJson);

      final jsonList = [buildJson, anotherJson];
      final builds = BuildkiteBuild.listFromJson(jsonList);

      expect(builds, equals([expectedBuild, anotherBuild]));
    });

    test(".toJson() converts an instance to the json map", () {
      final json = expectedBuild.toJson();

      expect(json, equals(buildJson));
    });
  });
}

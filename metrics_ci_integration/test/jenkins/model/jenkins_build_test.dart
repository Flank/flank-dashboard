import 'package:ci_integration/jenkins/model/jenkins_build.dart';
import 'package:test/test.dart';

void main() {
  group('JenkinsBuild', () {
    final currentMillisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;

    final buildJson = {
      'number': 1,
      'duration': 10,
      'timestamp': currentMillisecondsSinceEpoch,
      'result': 'FAILED',
      'url': 'url',
      'artifacts': [],
    };

    final jenkinsBuild = JenkinsBuild(
      number: 1,
      duration: const Duration(seconds: 10),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        currentMillisecondsSinceEpoch,
      ),
      result: 'FAILED',
      url: 'url',
      artifacts: const [],
    );

    test('.fromJson() should return null if a given json is null', () {
      final job = JenkinsBuild.fromJson(null);

      expect(job, isNull);
    });

    test('.fromJson() should create an instance from a json map', () {
      final job = JenkinsBuild.fromJson(buildJson);

      expect(job, equals(jenkinsBuild));
    });

    test(
      '.listFromJson() should map a null list as null one',
      () {
        final jobs = JenkinsBuild.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      '.listFromJson() should map an empty list as empty one',
      () {
        final jobs = JenkinsBuild.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      '.listFromJson() should map a list of jobs json maps',
      () {
        final jobs = JenkinsBuild.listFromJson([buildJson, buildJson]);

        expect(jobs, equals([jenkinsBuild, jenkinsBuild]));
      },
    );

    test('toJson() should include only non-null properties', () {
      const job = JenkinsBuild(number: 1);
      const expected = {'number': 1};
      final json = job.toJson();

      expect(json, equals(expected));
    });

    test('toJson() should convert an instance to the json map', () {
      final json = jenkinsBuild.toJson();

      expect(json, equals(buildJson));
    });
  });
}

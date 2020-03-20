import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsBuildingJob", () {
    Map<String, dynamic> buildingJobJson;
    JenkinsBuildingJob buildingJob;

    setUpAll(() {
      const firstBuild = JenkinsBuild(
        number: 1,
        url: 'firstBuildUrl',
      );
      const lastBuild = JenkinsBuild(
        number: 2,
        url: 'secondBuildUrl',
      );

      buildingJob = const JenkinsBuildingJob(
        name: 'name',
        fullName: 'fullName',
        url: 'url',
        builds: [lastBuild, firstBuild],
        firstBuild: firstBuild,
        lastBuild: lastBuild,
      );

      const firstBuildJson = {
        'number': 1,
        'duration': null,
        'timestamp': null,
        'result': null,
        'url': 'firstBuildUrl',
        'artifacts': null,
      };
      const lastBuildJson = {
        'number': 2,
        'duration': null,
        'timestamp': null,
        'result': null,
        'url': 'secondBuildUrl',
        'artifacts': null,
      };

      buildingJobJson = {
        'name': 'name',
        'fullName': 'fullName',
        'url': 'url',
        'builds': [lastBuildJson, firstBuildJson],
        'firstBuild': firstBuildJson,
        'lastBuild': lastBuildJson,
      };
    });

    test(".fromJson() should return null if the given json is null", () {
      final job = JenkinsBuildingJob.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() should create an instance from the json map", () {
      final job = JenkinsBuildingJob.fromJson(buildingJobJson);

      expect(job, equals(buildingJob));
    });

    test(".toJson() should populate a json map with a list of jobs", () {
      const job = JenkinsBuildingJob(name: 'name', builds: []);
      final json = job.toJson();

      expect(json, containsPair('builds', isEmpty));
    });

    test(".toJson() should convert an instance to the json map", () {
      final json = buildingJob.toJson();

      expect(json, equals(buildingJobJson));
    });
  });
}

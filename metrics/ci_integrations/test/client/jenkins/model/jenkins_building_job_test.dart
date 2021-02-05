import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/jenkins_artifacts_test_data.dart';

void main() {
  group("JenkinsBuildingJob", () {
    Map<String, dynamic> buildingJobJson;
    JenkinsBuildingJob buildingJob;
    Map<String, dynamic> jenkinsBuildJson;
    JenkinsBuild jenkinsBuild;

    setUpAll(() {
      const firstBuildNumber = 1;
      const firstBuildUrl = 'firstBuildUrl';
      const secondBuildNumber = 2;
      const secondBuildUrl = 'secondBuildUrl';
      const buildingJobName = 'name';
      const buildingJobFullName = 'fullName';
      const buildingJobUrl = 'url';

      const firstBuild = JenkinsBuild(
        number: firstBuildNumber,
        url: firstBuildUrl,
        artifacts: [JenkinsArtifactsTestData.fileArtifact],
      );

      const lastBuild = JenkinsBuild(
        number: secondBuildNumber,
        url: secondBuildUrl,
        artifacts: [JenkinsArtifactsTestData.coverageArtifact],
      );

      jenkinsBuild = firstBuild;

      buildingJob = const JenkinsBuildingJob(
        name: buildingJobName,
        fullName: buildingJobFullName,
        url: buildingJobUrl,
        builds: [lastBuild, firstBuild],
        firstBuild: firstBuild,
        lastBuild: lastBuild,
      );

      const firstBuildJson = {
        'number': firstBuildNumber,
        'duration': null,
        'timestamp': null,
        'result': null,
        'url': firstBuildUrl,
        'api_url': null,
        'artifacts': [JenkinsArtifactsTestData.fileArtifactJson],
      };

      jenkinsBuildJson = firstBuildJson;

      const lastBuildJson = {
        'number': secondBuildNumber,
        'duration': null,
        'timestamp': null,
        'result': null,
        'url': secondBuildUrl,
        'api_url': null,
        'artifacts': [JenkinsArtifactsTestData.coverageArtifactJson],
      };

      buildingJobJson = {
        'name': buildingJobName,
        'fullName': buildingJobFullName,
        'url': buildingJobUrl,
        'builds': [lastBuildJson, firstBuildJson],
        'firstBuild': firstBuildJson,
        'lastBuild': lastBuildJson,
      };
    });

    test(".fromJson() returns null if the given json is null", () {
      final job = JenkinsBuildingJob.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() creates an instance from the json map", () {
      final job = JenkinsBuildingJob.fromJson(buildingJobJson);

      expect(job, equals(buildingJob));
    });

    test(".toJson() populates a json map with a list of builds", () {
      final job = JenkinsBuildingJob(name: 'name', builds: [jenkinsBuild]);
      final json = job.toJson();

      expect(json, containsPair('builds', [jenkinsBuildJson]));
    });

    test(".toJson() converts an instance to the json map", () {
      final json = buildingJob.toJson();

      expect(json, equals(buildingJobJson));
    });
  });
}

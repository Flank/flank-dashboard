// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/jenkins_artifacts_test_data.dart';
import '../test_utils/test_data/jenkins_build_test_data.dart';

void main() {
  group("JenkinsBuildingJob", () {
    Map<String, dynamic> buildingJobJson;
    JenkinsBuildingJob buildingJob;
    Map<String, dynamic> jenkinsBuildJson;
    JenkinsBuild jenkinsBuild;

    setUpAll(() {
      const firstBuildNumber = 1;
      const firstBuildUrl = 'http://test.com/1';
      const secondBuildNumber = 2;
      const secondBuildUrl = 'http://test.com/2';
      const buildingJobName = 'name';
      const buildingJobFullName = 'fullName';
      const buildingJobUrl = 'url';

      final firstBuild = JenkinsBuild(
        number: firstBuildNumber,
        url: firstBuildUrl,
        apiUrl: JenkinsBuildTestData.getApiUrl('http://test.com', 1),
        artifacts: const [JenkinsArtifactsTestData.fileArtifact],
      );

      final lastBuild = JenkinsBuild(
        number: secondBuildNumber,
        url: secondBuildUrl,
        apiUrl: JenkinsBuildTestData.getApiUrl('http://test.com', 2),
        artifacts: const [JenkinsArtifactsTestData.coverageArtifact],
      );

      jenkinsBuild = firstBuild;

      buildingJob = JenkinsBuildingJob(
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
        'artifacts': [JenkinsArtifactsTestData.fileArtifactJson],
      };

      jenkinsBuildJson = firstBuildJson;

      const lastBuildJson = {
        'number': secondBuildNumber,
        'duration': null,
        'timestamp': null,
        'result': null,
        'url': secondBuildUrl,
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

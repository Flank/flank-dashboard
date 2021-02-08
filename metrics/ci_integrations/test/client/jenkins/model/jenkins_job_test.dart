// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsJob", () {
    const jobName = 'name';
    const jobFullName = 'fullName';
    const jobUrl = 'url';

    const jobJson = <String, dynamic>{
      'name': jobName,
      'fullName': jobFullName,
      'url': jobUrl,
    };

    const jenkinsJob = JenkinsJob(
      name: jobName,
      fullName: jobFullName,
      url: jobUrl,
    );

    test(".fromJson() returns null if a given json is null", () {
      final job = JenkinsJob.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final job = JenkinsJob.fromJson(jobJson);

      expect(job, equals(jenkinsJob));
    });

    test(
      ".fromJson() creates the JenkinsMultiBranchJob instance if a json map contains the 'jobs' property",
      () {
        final job = JenkinsJob.fromJson(const {
          'jobs': [
            {
              'name': 'subjob',
              'fullName': 'name/subjob',
              'url': 'subjobUrl',
            },
          ],
          ...jobJson,
        });

        expect(job, isA<JenkinsMultiBranchJob>());
      },
    );

    test(
      ".fromJson() creates the JenkinsBuildingJob instance if a json map contains the 'builds' property",
      () {
        final job = JenkinsJob.fromJson(const {
          'builds': [
            {
              'number': 1,
              'duration': 10,
            },
          ],
          ...jobJson,
        });
        expect(job, isA<JenkinsBuildingJob>());
      },
    );

    test(
      ".listFromJson() maps a null list as null one",
      () {
        final jobs = JenkinsJob.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list as empty one",
      () {
        final jobs = JenkinsJob.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of jobs json maps",
      () {
        final jobs = JenkinsJob.listFromJson([jobJson, jobJson]);

        expect(jobs, equals([jenkinsJob, jenkinsJob]));
      },
    );

    test(".toJson() converts an instance to the json map", () {
      final json = jenkinsJob.toJson();

      expect(json, equals(jobJson));
    });
  });
}

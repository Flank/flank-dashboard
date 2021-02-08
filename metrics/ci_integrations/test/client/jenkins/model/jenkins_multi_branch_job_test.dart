// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsMultiBranchJob", () {
    const name = 'job';
    const fullName = 'job';
    const url = 'url';
    const subJobUrl = 'subJobUrl';
    const subJobName = 'subJob';
    const subJobFullName = '$name/$subJobName';

    const multiBranchJobJson = {
      'name': name,
      'fullName': fullName,
      'url': url,
      'jobs': [
        {
          'name': subJobName,
          'fullName': subJobFullName,
          'url': subJobUrl,
        },
      ],
    };

    const multiBranchJob = JenkinsMultiBranchJob(
      name: name,
      fullName: fullName,
      url: url,
      jobs: [
        JenkinsJob(
          name: subJobName,
          fullName: subJobFullName,
          url: subJobUrl,
        ),
      ],
    );

    test(".fromJson() returns null if the given json is null", () {
      final job = JenkinsMultiBranchJob.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() creates an instance from the json map", () {
      final job = JenkinsMultiBranchJob.fromJson(multiBranchJobJson);

      expect(job, equals(multiBranchJob));
    });

    test(".toJson() populates a json map with a list of jobs", () {
      const job = JenkinsMultiBranchJob(name: 'name', jobs: []);
      final json = job.toJson();

      expect(json, containsPair('jobs', isEmpty));
    });

    test(".toJson() converts an instance to the json map", () {
      final json = multiBranchJob.toJson();

      expect(json, equals(multiBranchJobJson));
    });
  });
}

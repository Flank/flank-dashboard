// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:equatable/equatable.dart';

/// A class representing a Jenkins job.
///
/// Instances contain the general information about a Jenkins job, while
/// [JenkinsBuildingJob] and [JenkinsMultiBranchJob] specifies this information.
class JenkinsJob extends Equatable {
  /// The name of this job.
  final String name;

  /// The full name of this job.
  ///
  /// If this job is a top-level the full name coincides with its [name].
  /// Otherwise, the full name consists of names of top-level jobs and its own
  /// [name] separated by a `/`. For example, if a job with name `master` is a
  /// part of a multi-branch pipeline with the name `test` then the full name of
  /// `master` will be `test/master`.
  final String fullName;

  /// The browsable URL to this job.
  final String url;

  @override
  List<Object> get props => [name, fullName, url];

  /// Creates a new instance of the [JenkinsJob].
  const JenkinsJob({
    this.name,
    this.fullName,
    this.url,
  });

  /// Creates an instance of Jenkins job from the decoded JSON object.
  ///
  /// If [json] contains the `builds` key then delegates creating
  /// to [JenkinsBuildingJob.fromJson]. If [json] contains the `jobs` key then
  /// delegates creating to [JenkinsMultiBranchJob.fromJson]. Otherwise, creates
  /// [JenkinsJob] with general information about the job.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsJob.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json.containsKey('builds')) {
      return JenkinsBuildingJob.fromJson(json);
    } else if (json.containsKey('jobs')) {
      return JenkinsMultiBranchJob.fromJson(json);
    }

    return JenkinsJob(
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      url: json['url'] as String,
    );
  }

  /// Creates a list of jobs from the [list] of decoded JSON objects.
  ///
  /// Returns `null` if the given list is `null`.
  static List<JenkinsJob> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => JenkinsJob.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts object into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fullName': fullName,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'JenkinsJob ${toJson()}';
  }
}

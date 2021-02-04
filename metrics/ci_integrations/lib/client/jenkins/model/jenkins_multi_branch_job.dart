// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';

/// A class representing a Jenkins top-level job.
///
/// This stands for a job in Jenkins that contains other jobs. For example,
/// Multibranch Pipelines and Organization Folders
/// (https://jenkins.io/doc/book/pipeline/multibranch/) contain a list of
/// building pipelines and a list of Multibranch Pipelines respectively.
class JenkinsMultiBranchJob extends JenkinsJob {
  /// A list of jobs within this Jenkins job.
  final List<JenkinsJob> jobs;

  @override
  List<Object> get props => super.props..add(jobs);

  /// Creates a new instance of the [JenkinsMultiBranchJob].
  const JenkinsMultiBranchJob({
    String name,
    String fullName,
    String url,
    this.jobs,
  }) : super(name: name, fullName: fullName, url: url);

  /// Creates an instance of a multi-branch job from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsMultiBranchJob.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsMultiBranchJob(
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      url: json['url'] as String,
      jobs: JenkinsJob.listFromJson(json['jobs'] as List<dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'jobs': jobs?.map((b) => b.toJson())?.toList(),
      });
  }

  @override
  String toString() {
    return 'JenkinsMultiBranchJob ${toJson()}';
  }
}

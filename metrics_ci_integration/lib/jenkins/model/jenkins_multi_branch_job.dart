import 'package:ci_integration/jenkins/model/jenkins_job.dart';
import 'package:meta/meta.dart';

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

  const JenkinsMultiBranchJob({
    @required String name,
    String fullName,
    String url,
    this.jobs,
  }) : super(name: name, fullName: fullName, url: url);

  /// Creates an instance of multi-branch job from the decoded JSON object.
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

  /// Converts object into the [Map].
  /// The result can be encoded to a JSON object.
  ///
  /// The resulting map will include only non-null fields of an object it
  /// represents and can be encoded to a JSON object.
  /// Populates [JenkinsJob.toJson] with [jobs].
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();

    if (jobs != null) json['jobs'] = jobs.map((b) => b.toJson()).toList();

    return json;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

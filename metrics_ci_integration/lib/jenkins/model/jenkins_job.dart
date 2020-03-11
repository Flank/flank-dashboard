import 'package:ci_integration/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class representing a Jenkins job.
///
/// Instances contain the general information about a Jenkins job, while
/// [JenkinsBuildingJob] and [JenkinsMultiBranchJob] specifies this information.
class JenkinsJob extends Equatable {
  final String name;
  final String fullName;
  final String url;

  @override
  List<Object> get props => [name, fullName, url];

  const JenkinsJob({
    @required this.name,
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
  static List<JenkinsJob> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => JenkinsJob.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts object into the [Map].
  /// The result can be encoded to a JSON object.
  ///
  /// The resulting map will include only non-null fields of an object it
  /// represents and result can be encoded to a JSON object.
  /// The resulting map contains a general information about the job.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) json['name'] = name;
    if (fullName != null) json['fullName'] = fullName;
    if (url != null) json['url'] = url;

    return json;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

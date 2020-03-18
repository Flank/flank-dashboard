import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';

import 'jenkins_job.dart';

/// A class representing a Jenkins building job.
class JenkinsBuildingJob extends JenkinsJob {
  /// The first build performed within this job.
  final JenkinsBuild firstBuild;

  /// The current last build performed within this job.
  final JenkinsBuild lastBuild;

  /// A list of builds performed within this job.
  ///
  /// Contains either a full list of builds or a part of builds
  /// (see [JenkinsClient.fetchBuilds]).
  final List<JenkinsBuild> builds;

  @override
  List<Object> get props =>
      super.props..addAll([firstBuild, lastBuild, builds]);

  const JenkinsBuildingJob({
    String name,
    String fullName,
    String url,
    this.firstBuild,
    this.lastBuild,
    this.builds,
  }) : super(name: name, fullName: fullName, url: url);

  /// Creates an instance of building job from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsBuildingJob.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsBuildingJob(
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      url: json['url'] as String,
      firstBuild: JenkinsBuild.fromJson(
        json['firstBuild'] as Map<String, dynamic>,
      ),
      lastBuild: JenkinsBuild.fromJson(
        json['lastBuild'] as Map<String, dynamic>,
      ),
      builds: JenkinsBuild.listFromJson(json['builds'] as List<dynamic>),
    );
  }

  /// Converts object into the JSON encodable [Map].
  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'firstBuild': firstBuild?.toJson(),
        'lastBuild': lastBuild?.toJson(),
        'builds': builds?.map((b) => b.toJson())?.toList(),
      });
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

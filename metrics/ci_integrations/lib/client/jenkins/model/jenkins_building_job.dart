// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/deserializer/jenkins_build_deserializer.dart';
import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';

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

  /// Creates a new instance of the [JenkinsBuildingJob].
  const JenkinsBuildingJob({
    String name,
    String fullName,
    String url,
    this.firstBuild,
    this.lastBuild,
    this.builds,
  }) : super(name: name, fullName: fullName, url: url);

  /// Creates an instance of a building job from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsBuildingJob.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsBuildingJob(
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      url: json['url'] as String,
      firstBuild: JenkinsBuildDeserializer.fromJson(
        json['firstBuild'] as Map<String, dynamic>,
      ),
      lastBuild: JenkinsBuildDeserializer.fromJson(
        json['lastBuild'] as Map<String, dynamic>,
      ),
      builds: JenkinsBuildDeserializer.listFromJson(
        json['builds'] as List<dynamic>,
      ),
    );
  }

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
    return 'JenkinsBuildingJob ${toJson()}';
  }
}

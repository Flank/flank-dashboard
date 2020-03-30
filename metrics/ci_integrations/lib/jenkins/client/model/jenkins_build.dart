import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/util/jenkins_util.dart';
import 'package:equatable/equatable.dart';

/// A class representing a single Jenkins build.
class JenkinsBuild extends Equatable {
  /// A build number used to identify the build within a [JenkinsBuildingJob].
  ///
  /// This is unique only within a job's list of builds.
  final int number;

  /// A duration of this build.
  final Duration duration;

  /// A timestamp this build has been started at.
  final DateTime timestamp;

  /// A result of this build.
  final JenkinsBuildResult result;

  /// A link to access this build in Jenkins.
  final String url;

  /// A flag that indicates whether this build is in progress or not.
  final bool building;

  /// A list of [JenkinsBuildArtifact]s generated during the build.
  final List<JenkinsBuildArtifact> artifacts;

  @override
  List<Object> get props =>
      [number, duration, timestamp, result, url, artifacts];

  const JenkinsBuild({
    this.number,
    this.duration,
    this.timestamp,
    this.result,
    this.url,
    this.building,
    this.artifacts,
  });

  /// Creates an instance of Jenkins build from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsBuild.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final timestamp = json['timestamp'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int);
    final duration = json['duration'] == null
        ? null
        : Duration(seconds: json['duration'] as int);
    final result = JenkinsUtil.mapJenkinsBuildResult(json['result'] as String);

    return JenkinsBuild(
      number: json['number'] as int,
      duration: duration,
      timestamp: timestamp,
      result: result,
      url: json['url'] as String,
      building: json['building'] as bool,
      artifacts: JenkinsBuildArtifact.listFromJson(
        json['artifacts'] as List<dynamic>,
      ),
    );
  }

  /// Creates a list of Jenkins builds from the [list] of decoded JSON objects.
  ///
  /// Returns `null` if the given list is `null`.
  static List<JenkinsBuild> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => JenkinsBuild.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts object into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'duration': duration?.inSeconds,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'result': JenkinsUtil.unmapJenkinsBuildResult(result),
      'url': url,
      'artifacts': artifacts?.map((a) => a.toJson())?.toList()
    };
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

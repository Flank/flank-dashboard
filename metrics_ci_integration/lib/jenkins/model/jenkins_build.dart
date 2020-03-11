import 'package:ci_integration/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/model/jenkins_building_job.dart';
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
  final String result;

  /// A link to access this build in Jenkins.
  final String url;

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

    return JenkinsBuild(
      number: json['number'] as int,
      duration: duration,
      timestamp: timestamp,
      result: json['result'] as String,
      url: json['url'] as String,
      artifacts: JenkinsBuildArtifact.listFromJson(
        json['artifacts'] as List<dynamic>,
      ),
    );
  }

  /// Creates a list of Jenkins builds from the [list] of decoded JSON objects.
  static List<JenkinsBuild> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => JenkinsBuild.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts object into the [Map].
  ///
  /// The resulting map will include only non-null fields of an object it
  /// represents and can be encoded to a JSON object.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (number != null) json['number'] = number;
    if (duration != null) json['duration'] = duration.inSeconds;
    if (timestamp != null) json['timestamp'] = timestamp.millisecondsSinceEpoch;
    if (result != null) json['result'] = result;
    if (url != null) json['url'] = url;
    if (artifacts != null) {
      json['artifacts'] = artifacts.map((a) => a.toJson()).toList();
    }

    return json;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
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

  /// A link to access data of this build using Jenkins API.
  final String apiUrl;

  /// A link to access this build in Jenkins.
  final String url;

  /// A flag that indicates whether this build is in progress or not.
  final bool building;

  /// A list of [JenkinsBuildArtifact]s generated during the build.
  final List<JenkinsBuildArtifact> artifacts;

  @override
  List<Object> get props =>
      [number, duration, timestamp, result, apiUrl, url, artifacts];

  /// Creates a new instance of the [JenkinsBuild].
  const JenkinsBuild({
    this.number,
    this.duration,
    this.timestamp,
    this.result,
    this.apiUrl,
    this.url,
    this.building,
    this.artifacts,
  });

  /// Converts object into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const resultMapper = JenkinsBuildResultMapper();
    return {
      'number': number,
      'duration': duration?.inMilliseconds,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'result': resultMapper.unmap(result),
      'url': url,
      'artifacts': artifacts?.map((a) => a.toJson())?.toList()
    };
  }

  @override
  String toString() {
    return 'JenkinsBuild ${toJson()}';
  }
}

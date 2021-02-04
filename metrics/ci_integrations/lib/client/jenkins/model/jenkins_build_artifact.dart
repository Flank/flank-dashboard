// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:equatable/equatable.dart';

/// A class representing a single artifact of a [JenkinsBuild].
class JenkinsBuildArtifact extends Equatable {
  /// A name of this artifact file.
  final String fileName;

  /// A path to this artifact in the build's artifacts tree stored within
  /// Jenkins instance.
  final String relativePath;

  @override
  List<Object> get props => [fileName, relativePath];

  /// Creates a new instance of the [JenkinsBuildArtifact].
  const JenkinsBuildArtifact({
    this.fileName,
    this.relativePath,
  });

  /// Creates an instance of build's artifact from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsBuildArtifact.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsBuildArtifact(
      fileName: json['fileName'] as String,
      relativePath: json['relativePath'] as String,
    );
  }

  /// Creates a list of artifacts from the [list] of decoded JSON objects.
  ///
  /// Returns `null` if the given list is `null`.
  static List<JenkinsBuildArtifact> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) =>
            JenkinsBuildArtifact.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts object into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'relativePath': relativePath,
    };
  }

  @override
  String toString() {
    return 'JenkinsBuildArtifact ${toJson()}';
  }
}

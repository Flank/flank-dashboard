import 'package:ci_integration/jenkins/model/jenkins_build.dart';
import 'package:equatable/equatable.dart';

/// A class representing a single artifact of a [JenkinsBuild].
class JenkinsBuildArtifact extends Equatable {
  /// A name of this artifact file.
  final String fileName;

  /// A path to this artifact.
  final String relativePath;

  @override
  List<Object> get props => [fileName, relativePath];

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
  static List<JenkinsBuildArtifact> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) =>
            JenkinsBuildArtifact.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts object into the [Map].
  ///
  /// The resulting map will include only non-null fields of an object it
  /// represents and can be encoded to a JSON object.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (fileName != null) json['fileName'] = fileName;
    if (relativePath != null) json['relativePath'] = relativePath;

    return json;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

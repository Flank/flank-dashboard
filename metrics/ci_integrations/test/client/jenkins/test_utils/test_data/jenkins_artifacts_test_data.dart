// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';

/// A class providing a test data for [JenkinsBuildArtifact].
class JenkinsArtifactsTestData {
  /// A file name for the coverage artifact.
  static const String _coverageFileName = 'coverage.json';

  /// A relative path to the coverage artifact within Jenkins instance.
  static const String _coverageRelativePath = 'coverage/coverage.json';

  /// A file name for the test artifact.
  static const String _fileName = 'file.json';

  /// A relative path to the test artifact.
  static const String _relativePath = 'files/file.json';

  /// A decoded JSON object representing the coverage artifact.
  static const Map<String, dynamic> coverageArtifactJson = {
    'fileName': _coverageFileName,
    'relativePath': _coverageRelativePath,
  };

  /// A decoded JSON object representing the test artifact.
  static const Map<String, dynamic> fileArtifactJson = {
    'fileName': _fileName,
    'relativePath': _relativePath,
  };

  /// A list of the decoded JSON objects representing test artifacts.
  static const List<Map<String, dynamic>> artifactsJson = [
    coverageArtifactJson,
    fileArtifactJson,
  ];

  /// A [JenkinsBuildArtifact] instance representing the coverage artifact.
  static const JenkinsBuildArtifact coverageArtifact = JenkinsBuildArtifact(
    fileName: _coverageFileName,
    relativePath: _coverageRelativePath,
  );

  /// A [JenkinsBuildArtifact] instance representing the test artifact.
  static const JenkinsBuildArtifact fileArtifact = JenkinsBuildArtifact(
    fileName: _fileName,
    relativePath: _relativePath,
  );

  /// A list of the [JenkinsBuildArtifact] instances representing test artifacts.
  static const List<JenkinsBuildArtifact> artifacts = [
    coverageArtifact,
    fileArtifact,
  ];
}

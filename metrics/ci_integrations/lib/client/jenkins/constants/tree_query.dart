// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';

/// A class that contains a `tree` query parameter's parts each standing for
/// the properties of data to fetch.
class TreeQuery {
  /// The part of the `tree` query parameter that stands for
  /// [JenkinsBuildArtifact]'s properties to fetch.
  static const String artifacts = 'fileName,relativePath';

  /// The part of the `tree` query parameter that stands for [JenkinsBuild]'s
  /// properties to fetch.
  static const String build =
      'number,duration,timestamp,result,url,building,artifacts[$artifacts]';

  /// The part of the `tree` query parameter that stands for [JenkinsJob]'s
  /// properties to fetch.
  static const String jobBase = 'name,fullName,url';

  /// The part of the `tree` query parameter that extends common [JenkinsJob]'s
  /// properties to fetch with `jobs` and `builds` to be able detect a job type.
  static const String job = '$jobBase,jobs{,0},builds{,0}';
}

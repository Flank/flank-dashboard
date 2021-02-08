// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class providing methods for mapping Jenkins build result.
class JenkinsBuildResultMapper implements Mapper<String, JenkinsBuildResult> {
  /// A constant for the `ABORTED` result of Jenkins build.
  static const String aborted = 'ABORTED';

  /// A constant for the `NOT_BUILT` result of Jenkins build.
  static const String notBuilt = 'NOT_BUILT';

  /// A constant for the `FAILURE` result of Jenkins build.
  static const String failure = 'FAILURE';

  /// A constant for the `SUCCESS` result of Jenkins build.
  static const String success = 'SUCCESS';

  /// A constant for the `UNSTABLE` result of Jenkins build.
  static const String unstable = 'UNSTABLE';

  /// Creates a new instance of the [JenkinsBuildResultMapper].
  const JenkinsBuildResultMapper();

  @override
  JenkinsBuildResult map(String result) {
    switch (result) {
      case aborted:
        return JenkinsBuildResult.aborted;
      case notBuilt:
        return JenkinsBuildResult.notBuild;
      case failure:
        return JenkinsBuildResult.failure;
      case success:
        return JenkinsBuildResult.success;
      case unstable:
        return JenkinsBuildResult.unstable;
      default:
        return null;
    }
  }

  @override
  String unmap(JenkinsBuildResult result) {
    switch (result) {
      case JenkinsBuildResult.aborted:
        return aborted;
      case JenkinsBuildResult.notBuild:
        return notBuilt;
      case JenkinsBuildResult.failure:
        return failure;
      case JenkinsBuildResult.success:
        return success;
      case JenkinsBuildResult.unstable:
        return unstable;
      default:
        return null;
    }
  }
}

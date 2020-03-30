import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';

/// A utility class providing methods for mapping Jenkins specific data.
class JenkinsUtil {
  /// Maps the [result] of Jenkins build to the [JenkinsBuildResult].
  static JenkinsBuildResult mapJenkinsBuildResult(String result) {
    switch (result) {
      case 'ABORTED':
        return JenkinsBuildResult.aborted;
      case 'NOT_BUILT':
        return JenkinsBuildResult.notBuild;
      case 'FAILURE':
        return JenkinsBuildResult.failure;
      case 'SUCCESS':
        return JenkinsBuildResult.success;
      case 'UNSTABLE':
        return JenkinsBuildResult.unstable;
      default:
        return null;
    }
  }

  /// Maps the [result] of Jenkins build to the form of Jenkins API.
  static String unmapJenkinsBuildResult(JenkinsBuildResult result) {
    switch (result) {
      case JenkinsBuildResult.aborted:
        return 'ABORTED';
      case JenkinsBuildResult.notBuild:
        return 'NOT_BUILT';
      case JenkinsBuildResult.failure:
        return 'FAILURE';
      case JenkinsBuildResult.success:
        return 'SUCCESS';
      case JenkinsBuildResult.unstable:
        return 'UNSTABLE';
      default:
        return null;
    }
  }
}

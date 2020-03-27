import 'package:metrics_core/metrics_core.dart';

/// A utility class providing methods for mapping Jenkins specific data.
class JenkinsUtil {
  /// Maps the [result] of Jenkins build to the [BuildStatus].
  static BuildStatus mapJenkinsBuildResult(String result) {
    if (result == 'ABORTED') {
      return BuildStatus.cancelled;
    } else if (result == 'SUCCESS' || result == 'UNSTABLE') {
      return BuildStatus.successful;
    }

    return BuildStatus.failed;
  }
}

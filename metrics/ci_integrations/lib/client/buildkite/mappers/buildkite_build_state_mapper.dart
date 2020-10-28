import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Buildkite build statuses.
class BuildkiteBuildStateMapper implements Mapper<String, BuildkiteBuildState> {
  /// A running build status.
  static const String running = 'running';

  /// A scheduled build status.
  static const String scheduled = 'scheduled';

  /// A successful finished build status.
  static const String passed = 'passed';

  /// A failed build status.
  static const String failed = 'failed';

  /// A status that indicates the build blocked by another build.
  static const String blocked = 'blocked';

  /// A canceled build status.
  static const String canceled = 'canceled';

  /// A canceling build status.
  static const String canceling = 'canceling';

  /// A skipped build status.
  static const String skipped = 'skipped';

  /// A status that indicates the build has never run.
  static const String notRun = 'not_run';

  /// A finished build status.
  static const String finished = 'finished';

  /// Creates a new instance of the [BuildkiteBuildStateMapper].
  const BuildkiteBuildStateMapper();

  @override
  BuildkiteBuildState map(String value) {
    switch (value) {
      case running:
        return BuildkiteBuildState.running;
      case scheduled:
        return BuildkiteBuildState.scheduled;
      case passed:
        return BuildkiteBuildState.passed;
      case failed:
        return BuildkiteBuildState.failed;
      case blocked:
        return BuildkiteBuildState.blocked;
      case canceled:
        return BuildkiteBuildState.canceled;
      case canceling:
        return BuildkiteBuildState.canceling;
      case skipped:
        return BuildkiteBuildState.skipped;
      case notRun:
        return BuildkiteBuildState.notRun;
      case finished:
        return BuildkiteBuildState.finished;
      default:
        return null;
    }
  }

  @override
  String unmap(BuildkiteBuildState value) {
    switch (value) {
      case BuildkiteBuildState.running:
        return running;
      case BuildkiteBuildState.scheduled:
        return scheduled;
      case BuildkiteBuildState.passed:
        return passed;
      case BuildkiteBuildState.failed:
        return failed;
      case BuildkiteBuildState.blocked:
        return blocked;
      case BuildkiteBuildState.canceled:
        return canceled;
      case BuildkiteBuildState.canceling:
        return canceling;
      case BuildkiteBuildState.skipped:
        return skipped;
      case BuildkiteBuildState.notRun:
        return notRun;
      case BuildkiteBuildState.finished:
        return finished;
      default:
        return null;
    }
  }
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Buildkite build states.
class BuildkiteBuildStateMapper implements Mapper<String, BuildkiteBuildState> {
  /// A state for a running build.
  static const String running = 'running';

  /// A state for a scheduled build.
  static const String scheduled = 'scheduled';

  /// A state for a successfully passed build.
  static const String passed = 'passed';

  /// A state for a failed build.
  static const String failed = 'failed';

  /// A shortcut state that indicates builds which are blocked by
  /// a pipeline step.
  static const String blocked = 'blocked';

  /// A state for a canceled build.
  static const String canceled = 'canceled';

  /// A state for a build that is being canceled.
  static const String canceling = 'canceling';

  /// A state for a skipped build.
  static const String skipped = 'skipped';

  /// A state that indicates the build has never run.
  static const String notRun = 'not_run';

  /// A shortcut state that indicates builds with passed, failed, blocked,
  /// or canceled states.
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

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that contains method for generating Build test data
/// to use in tests.
class BuildTestDataGenerator {
  /// A project id to use in this test data generator.
  final String projectId;

  /// A start [DateTime] to use in this test data generator.
  final DateTime startedAt;

  /// A [BuildStatus] to use in this test data generator.
  final BuildStatus buildStatus;

  /// A [Duration] to use in this test data generator.
  final Duration duration;

  /// Creates a new instance of the [BuildTestDataGenerator].
  ///
  /// The [buildStatus] defaults to `BuildStatus.successful`.
  /// The [duration] defaults to `Duration(milliseconds: 100)`.
  BuildTestDataGenerator({
    this.projectId,
    this.startedAt,
    this.buildStatus = BuildStatus.successful,
    this.duration = const Duration(milliseconds: 100),
  });

  /// Generates a [Map] from the [BuildData] instance.
  Map<String, dynamic> generateJson() {
    final buildData = BuildData(
      projectId: projectId,
      buildStatus: buildStatus,
      duration: duration,
      startedAt: startedAt ?? DateTime.now(),
    );

    final json = buildData.toJson();
    json['startedAt'] = Timestamp.fromDateTime(buildData.startedAt);

    return json;
  }
}

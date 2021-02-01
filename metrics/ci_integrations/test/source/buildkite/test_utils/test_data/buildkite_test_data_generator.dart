import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that contains methods for generating Buildkite test data
/// to use in tests.
///
/// The generator uses the values it is initialized with as the default values
/// to the data being generated.
class BuildkiteTestDataGenerator {
  /// A pipeline identifier to use in this test data generator.
  final String pipelineSlug;

  /// A [Percent] coverage to use in this test data generator.
  final Percent coverage;

  // An API endpoint to use in this test data generator.
  final String apiUrl;

  /// A url to use in this test data generator.
  final String webUrl;

  /// A start [DateTime] to use in this test data generator.
  final DateTime startedAt;

  /// A finish [DateTime] to use in this test data generator.
  final DateTime finishedAt;

  /// A [Duration] to use in this test data generator.
  final Duration duration;

  /// Creates a new instance of the [BuildkiteTestDataGenerator].
  const BuildkiteTestDataGenerator({
    this.pipelineSlug,
    this.coverage,
    this.apiUrl,
    this.webUrl,
    this.startedAt,
    this.finishedAt,
    this.duration,
  });

  /// Generates a [BuildkiteBuild] instance using the given parameters
  /// and default values.
  ///
  /// The [id] defaults to `test1`.
  /// The [number] defaults to `1`.
  /// The [blocked] defaults to `false`.
  /// The [state] defaults to [BuildkiteBuildState.passed].
  BuildkiteBuild generateBuildkiteBuild({
    String id = 'test1',
    int number = 1,
    bool blocked = false,
    BuildkiteBuildState state = BuildkiteBuildState.passed,
  }) {
    return BuildkiteBuild(
      id: id,
      number: number,
      blocked: blocked,
      apiUrl: apiUrl,
      webUrl: webUrl,
      state: state,
      startedAt: startedAt,
      finishedAt: finishedAt,
    );
  }

  /// Generates a list of [BuildkiteBuild]s using the given [buildNumbers].
  ///
  /// The [buildNumbers] defaults to an empty list.
  List<BuildkiteBuild> generateBuildkiteBuildsByNumbers({
    List<int> buildNumbers = const [],
  }) {
    return buildNumbers.map((number) {
      return generateBuildkiteBuild(id: '$number', number: number);
    }).toList();
  }

  /// Generates a list of [BuildkiteBuild]s using the given [states].
  ///
  /// The [states] defaults to an empty list.
  List<BuildkiteBuild> generateBuildkiteBuildsByStates({
    List<BuildkiteBuildState> states = const [],
  }) {
    final result = <BuildkiteBuild>[];

    for (int i = 0; i < states.length; i++) {
      result.add(generateBuildkiteBuild(
        id: "${i + 1}",
        number: i + 1,
        state: states[i],
      ));
    }

    return result;
  }

  /// Generates a [BuildData] instance using the given parameters
  /// and default values.
  ///
  /// The [buildStatus] defaults to the [BuildStatus.successful].
  BuildData generateBuildData({
    int buildNumber,
    BuildStatus buildStatus = BuildStatus.successful,
  }) {
    return BuildData(
      buildNumber: buildNumber,
      startedAt: startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: pipelineSlug,
      url: webUrl,
      apiUrl: apiUrl,
      coverage: coverage,
    );
  }

  /// Generates a list of [BuildData] using the given [buildNumbers].
  ///
  /// The [buildNumbers] defaults to an empty list.
  List<BuildData> generateBuildDataByNumbers({
    List<int> buildNumbers = const [],
  }) {
    return buildNumbers.map((number) {
      return generateBuildData(buildNumber: number);
    }).toList();
  }

  /// Generates a list of [BuildData] using the given [states].
  ///
  /// The [states] defaults to an empty list.
  List<BuildData> generateBuildDataByStates({
    List<BuildStatus> states = const [],
  }) {
    final result = <BuildData>[];

    for (int i = 0; i < states.length; i++) {
      result.add(generateBuildData(
        buildNumber: i + 1,
        buildStatus: states[i],
      ));
    }

    return result;
  }
}

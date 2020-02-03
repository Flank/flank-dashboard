import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:test/test.dart';

void main() {
  const projectId = 'projectId';
  const projectIdParam = ProjectIdParam(projectId: projectId);
  const GetCoverageTestbed getCoverage = GetCoverageTestbed();
  const GetBuildMetricsTestbed getBuildMetrics = GetBuildMetricsTestbed();

  ProjectMetricsStore projectMetricsStore;

  setUp(() {
    projectMetricsStore = ProjectMetricsStore(
      getCoverage,
      getBuildMetrics,
    );
  });

  group("Metrics store creation", () {
    test("Throws an assert if one of the use cases is null", () {
      final assertionMatcher = throwsA(const TypeMatcher<AssertionError>());

      expect(() => ProjectMetricsStore(null, null), assertionMatcher);
      expect(
        () => ProjectMetricsStore(getCoverage, null),
        assertionMatcher,
      );
      expect(
        () => ProjectMetricsStore(null, getBuildMetrics),
        assertionMatcher,
      );
    });
  });

  group("Coverage data loading", () {
    test("Properly loads the coverage data", () async {
      final actualCoverage = await getCoverage(projectIdParam);

      await projectMetricsStore.getCoverage(projectId);

      expect(actualCoverage, equals(projectMetricsStore.coverage));
    });
  });
}

class GetCoverageTestbed implements GetProjectCoverage {
  static const double _coveragePercent = 0.3;

  const GetCoverageTestbed();

  @override
  Future<Coverage> call(ProjectIdParam params) {
    return Future.value(const Coverage(percent: _coveragePercent));
  }
}

class GetBuildMetricsTestbed implements GetBuildMetrics {
  const GetBuildMetricsTestbed();

  @override
  Future<BuildMetrics> call(ProjectIdParam param) {
    return Future.value(null);
  }
}

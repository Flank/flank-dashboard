import 'package:flutter/cupertino.dart';
import 'package:metrics/features/dashboard/data/repositories/metrics_repository_impl.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Creates project stores and injects it using the [Injector] widget.
class InjectionContainer extends StatefulWidget {
  final Widget child;

  const InjectionContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _InjectionContainerState createState() => _InjectionContainerState();
}

class _InjectionContainerState extends State<InjectionContainer> {
  final MetricsRepository _metrics = MetricsRepositoryImpl();
  GetProjectCoverage _getProjectCoverage;
  GetBuildMetrics _getBuildMetrics;

  @override
  void initState() {
    _getProjectCoverage = GetProjectCoverage(_metrics);
    _getBuildMetrics = GetBuildMetrics(_metrics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<ProjectMetricsStore>(
            () => ProjectMetricsStore(_getProjectCoverage, _getBuildMetrics)),
        Inject<ThemeStore>(() => ThemeStore()),
      ],
      initState: _initInjectorState,
      builder: (BuildContext context) => widget.child,
    );
  }

  /// Initiates the injector state.
  void _initInjectorState() {
    Injector.getAsReactive<ProjectMetricsStore>().setState(_initMetricsStore);
    Injector.getAsReactive<ThemeStore>()
        .setState((store) => store.isDark = false);
  }

  /// Initiates the [ProjectMetricsStore].
  Future _initMetricsStore(ProjectMetricsStore store) async {
    const projectId = 'projectId';

    await store.getCoverage(projectId);
    await store.getBuildMetrics(projectId);
  }
}

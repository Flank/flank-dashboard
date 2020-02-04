import 'package:flutter/cupertino.dart';
import 'package:metrics/features/dashboard/data/repositories/metrics_repository_impl.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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
  final MetricsRepository _repository = MetricsRepositoryImpl();
  GetProjectCoverage _getProjectCoverage;
  GetBuildMetrics _getBuildMetrics;

  @override
  void initState() {
    _getProjectCoverage = GetProjectCoverage(_repository);
    _getBuildMetrics = GetBuildMetrics(_repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<ProjectMetricsStore>(
            () => ProjectMetricsStore(_getProjectCoverage, _getBuildMetrics)),
      ],
      initState: _initCoverageStore,
      builder: (BuildContext context) => widget.child,
    );
  }

  void _initCoverageStore() {
    const projectId = 'projectId';

    Injector.getAsReactive<ProjectMetricsStore>().setState((store) async {
      await store.getCoverage(projectId);
      return store.getBuildMetrics(projectId);
    });
  }
}

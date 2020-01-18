import 'package:flutter/cupertino.dart';
import 'package:metrics/features/dashboard/data/repositories/metrics_repository_impl.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/presentation/state/coverage_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class InjectionContainer extends StatefulWidget {
  final Widget child;

  InjectionContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _InjectionContainerState createState() => _InjectionContainerState();
}

class _InjectionContainerState extends State<InjectionContainer> {
  final MetricsRepository _repository = MetricsRepositoryImpl();
  GetProjectCoverage _getProjectCoverage;

  @override
  void initState() {
    _getProjectCoverage = GetProjectCoverage(_repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<CoverageStore>(() => CoverageStore(_getProjectCoverage)),
      ],
      initState: _initCoverageStore,
      builder: (BuildContext context) => widget.child,
    );
  }

  void _initCoverageStore() {
    Injector.getAsReactive<CoverageStore>()
        .setState((store) => store.getCoverage('projectId'));
  }
}

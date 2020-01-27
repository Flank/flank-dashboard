import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';

import '../../domain/entities/coverage.dart';

class CoverageStore {
  final GetProjectCoverage _getCoverage;
  Coverage _coverage;

  CoverageStore(this._getCoverage);

  Coverage get coverage => _coverage;

  Future getCoverage(String projectId) async {
    _coverage = await _getCoverage(ProjectIdParam(projectId: projectId));
  }
}

import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/performance_chart_point_adapter.dart';
import 'package:metrics/features/dashboard/presentation/model/chart_point.dart';

/// Adopts the [Build] duration and result to match the [ChartPoint]
///
/// Represents the [_build] duration and result of the [Build]
class BuildResultChartPointAdapter extends PerformanceChartPointAdapter {
  final Build _build;

  BuildResultChartPointAdapter(this._build) : super(_build);

  BuildResult get result => _build.result;
}

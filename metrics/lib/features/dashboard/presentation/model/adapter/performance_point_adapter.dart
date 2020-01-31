import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/presentation/model/chart_point.dart';

/// Adapts [Build] duration to match the [ChartPoint].
///
/// Represents the [_build] duration of the [Build].
class PerformancePointAdapter implements ChartPoint {
  final Build _build;

  PerformancePointAdapter(this._build);

  @override
  num get x => _build.startedAt.millisecondsSinceEpoch;

  @override
  num get y => _build.duration.inMilliseconds;
}

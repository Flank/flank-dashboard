import 'package:metrics/features/dashboard/presentation/model/chart_point.dart';

/// Adopts the build [_day] and [_buildsNumber] to match the [ChartPoint].
///
/// Represents the [_buildsNumber] in some [_day].
class BuildPointAdapter implements ChartPoint {
  final DateTime _day;
  final int _buildsNumber;

  BuildPointAdapter(this._day, this._buildsNumber);

  @override
  num get x => _day.millisecondsSinceEpoch;

  @override
  num get y => _buildsNumber;
}

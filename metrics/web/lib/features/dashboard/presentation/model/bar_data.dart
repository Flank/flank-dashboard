import 'package:meta/meta.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';

/// Base class for representing the bar in [BarGraph].
///
/// This class presents the abstract interface for all bars.
@immutable
abstract class BarData {
  num get value;
}

import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/presentation/model/bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';

/// Represents the data of the bar to display in [BarGraph].
///
/// The [value] is the bar bar value.
/// The height of the bar will be calculated based on this value.
/// [result] is the result of the build.
/// The color of the [BuildResultBar] will be obtained from this value.
/// [url] is the url of the CI build.
class BuildResultBarData implements BarData {
  @override
  final int value;
  final BuildResult result;
  final String url;

  const BuildResultBarData({
    this.value,
    this.result,
    this.url,
  });
}

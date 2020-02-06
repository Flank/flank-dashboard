import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar.dart';

/// Represents the data of the [BuildResultBar] to display.
///
/// The [value] is the bar bar value.
/// The height of the bar will be calculated based on this value.
/// [result] is the result of the build.
/// The color of the [BuildResultBar] will be obtained from this value.
/// [url] is the url of the CI build.
class BuildResultBarData {
  final int value;
  final BuildResult result;
  final String url;

  const BuildResultBarData({
    this.value,
    this.result,
    this.url,
  });
}

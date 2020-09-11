import 'package:meta/meta.dart';

/// A view model class with the build number metrics data.
@immutable
class BuildNumberScorecardViewModel {
  /// A number of builds to display.
  final int numberOfBuilds;

  /// Creates the [BuildNumberScorecardViewModel] instance with
  /// the given [numberOfBuilds].
  const BuildNumberScorecardViewModel({
    this.numberOfBuilds,
  });
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// A view model class with the build number metric data.
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

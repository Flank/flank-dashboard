import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_bar_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';

/// A class that represents the strategy of applying the [EdgeInsets]
/// to the [BuildResultBar] based on the [BuildResultBarViewModel] position.
class BuildResultBarPaddingStrategy {
  /// A list of [BuildResultBarViewModel]s.
  final List<BuildResultBarViewModel> buildResults;

  /// Creates a new instance of the [BuildResultBarPaddingStrategy].
  ///
  /// The [buildResults] default value is an empty [List].
  const BuildResultBarPaddingStrategy({
    this.buildResults = const [],
  });

  /// Provides the [EdgeInsets] based on the [buildResult] position
  /// among the [buildResults].
  EdgeInsets getBarPadding(BuildResultBarViewModel buildResult) {
    final index = buildResults.indexOf(buildResult);

    if (index == buildResults.length - 1) {
      return const EdgeInsets.only(left: 2.0);
    }

    if (index == 0) {
      return const EdgeInsets.only(right: 2.0);
    }

    return const EdgeInsets.symmetric(horizontal: 2.0);
  }
}

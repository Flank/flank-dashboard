import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';

/// A class that represents the strategy of applying the [EdgeInsets]
/// to the [BuildResultBar] based on the [BuildResultViewModel] position.
class BuildResultBarPaddingStrategy {
  /// A list of [BuildResultViewModel]s.
  final List<BuildResultViewModel> buildResults;

  /// Creates a new instance of the [BuildResultBarPaddingStrategy].
  ///
  /// The [buildResults] default value is an empty [List].
  const BuildResultBarPaddingStrategy({
    this.buildResults = const [],
  });

  /// Provides the [EdgeInsets] based on the [buildResult] position
  /// among the [buildResults].
  EdgeInsets getBarPadding(BuildResultViewModel buildResult) {
    final index = buildResults.indexOf(buildResult);

    if (index == buildResults.length - 1) {
      return const EdgeInsets.only(left: 1.0);
    }

    if (index == 0) {
      return const EdgeInsets.only(right: 1.0);
    }

    return const EdgeInsets.symmetric(horizontal: 1.0);
  }
}

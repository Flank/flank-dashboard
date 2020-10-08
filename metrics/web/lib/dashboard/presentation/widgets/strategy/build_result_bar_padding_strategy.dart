import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';

/// A class that represents the strategy of applying the [EdgeInsets]
/// to the [BuildResultBar] based on the [BuildResultViewModel] value.
class BuildResultBarPaddingStrategy {
  /// A list of [BuildResultViewModel]s.
  final List<BuildResultViewModel> buildResultViewModels;

  /// Creates a new instance of the [BuildResultBarPaddingStrategy].
  ///
  /// The [buildResultViewModels] default value is an empty [List].
  const BuildResultBarPaddingStrategy({
    this.buildResultViewModels = const [],
  });

  /// Provides the [EdgeInsets] based on the [buildResult].
  EdgeInsets getBarPadding(BuildResultViewModel buildResult) {
    final index = buildResultViewModels.indexOf(buildResult);
    final isFirst = index == 0;

    if (isFirst) {
      return const EdgeInsets.only(right: 2.0);
    }

    final isLast = index == buildResultViewModels.length - 1;

    if (isLast) {
      return const EdgeInsets.only(left: 2.0);
    }

    return const EdgeInsets.symmetric(horizontal: 2.0);
  }
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';

/// Represents the build results metric entity.
class BuildResultMetric extends Equatable {
  /// A [List] of the build results.
  final List<BuildResult> buildResults;

  @override
  List<Object> get props => [buildResults];

  /// Creates the [BuildResultMetric].
  ///
  /// [buildResults] represents the results of several builds.
  const BuildResultMetric({this.buildResults = const []});
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represents the CI build [buildStatus] on specified [date].
///
/// Contains the data about build [url] and build [duration].
class BuildResult extends Equatable {
  /// A [DateTime] the build has been started at.
  final DateTime date;

  /// A [Duration] of the build.
  final Duration duration;

  /// A [BuildStatus] of the build.
  final BuildStatus buildStatus;

  /// A URL to access the build.
  final String url;

  @override
  List<Object> get props => [date, duration, buildStatus, url];

  /// Creates a new instance of the [BuildResult].
  const BuildResult({
    this.date,
    this.duration,
    this.buildStatus,
    this.url,
  });
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics_core/src/domain/entities/build_status.dart';
import 'package:metrics_core/src/domain/value_objects/percent.dart';

/// Represents a single finished build from CI.
class Build extends Equatable {
  /// A unique identifier of this build.
  final String id;

  /// A unique identifier of the project this build belongs to.
  final String projectId;

  /// A number of this build.
  final int buildNumber;

  /// A [DateTime] this build has been started at.
  final DateTime startedAt;

  /// A resulting status of this build.
  final BuildStatus buildStatus;

  /// A [Duration] of this build.
  final Duration duration;

  /// A name of the workflow that was used to run the build.
  final String workflowName;

  /// A URL of the source control revision used to run the build.
  final String url;

  /// A URL that represents an endpoint to fetch the data of this build 
  /// using API of the appropriate CI.
  final String apiUrl;

  /// A project test coverage percent of this build.
  final Percent coverage;

  /// Creates a new instance of the [Build].
  const Build({
    this.id,
    this.projectId,
    this.buildNumber,
    this.startedAt,
    this.buildStatus,
    this.duration,
    this.workflowName,
    this.url,
    this.apiUrl,
    this.coverage,
  });

  @override
  List<Object> get props =>
      [buildNumber, startedAt, buildStatus, duration, workflowName];
}

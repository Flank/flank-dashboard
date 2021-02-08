// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/mappers/buildkite_build_state_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a single Buildkite build.
class BuildkiteBuild extends Equatable {
  /// A unique identifier of this build.
  final String id;

  /// An order number of this build in the pipeline.
  final int number;

  /// Indicates whether this build blocked by a pipeline step.
  final bool blocked;

  /// A state of this build.
  final BuildkiteBuildState state;

  /// A link to access data of this build using Buildkite API.
  final String apiUrl;

  /// A link to access this build in Buildkite.
  final String webUrl;

  /// A timestamp this build has started at.
  final DateTime startedAt;

  /// A timestamp this build has finished at.
  final DateTime finishedAt;

  @override
  List<Object> get props =>
      [id, number, blocked, state, webUrl, startedAt, finishedAt];

  /// Creates a new instance of the [BuildkiteBuild].
  const BuildkiteBuild({
    this.id,
    this.number,
    this.blocked,
    this.state,
    this.apiUrl,
    this.webUrl,
    this.startedAt,
    this.finishedAt,
  });

  /// Creates a new instance of the [BuildkiteBuild] from the decoded JSON
  /// object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteBuild.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const stateMapper = BuildkiteBuildStateMapper();
    final state = stateMapper.map(json['state'] as String);

    final startedAt = json['started_at'] == null
        ? null
        : DateTime.parse(json['started_at'] as String);

    final finishedAt = json['finished_at'] == null
        ? null
        : DateTime.parse(json['finished_at'] as String);

    return BuildkiteBuild(
      id: json['id'] as String,
      number: json['number'] as int,
      blocked: json['blocked'] as bool,
      apiUrl: json['url'] as String,
      webUrl: json['web_url'] as String,
      state: state,
      startedAt: startedAt,
      finishedAt: finishedAt,
    );
  }

  /// Creates a list of [BuildkiteBuild] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkiteBuild> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => BuildkiteBuild.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this build instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const stateMapper = BuildkiteBuildStateMapper();

    return <String, dynamic>{
      'id': id,
      'number': number,
      'blocked': blocked,
      'url': apiUrl,
      'web_url': webUrl,
      'state': stateMapper.unmap(state),
      'started_at': startedAt?.toIso8601String(),
      'finished_at': finishedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BuildkiteBuild ${toJson()}';
  }
}

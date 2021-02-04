// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_action_conclusion_mapper.dart';
import 'package:ci_integration/client/github_actions/mappers/github_action_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a single Github Actions workflow run job.
class WorkflowRunJob extends Equatable {
  /// A unique identifier of this workflow run job.
  final int id;

  /// A unique identifier of a [WorkflowRun] this workflow run job belongs to.
  final int runId;

  /// A name of this workflow run job.
  final String name;

  /// A link to access this workflow run job in Github web UI.
  final String url;

  /// A status of this workflow run job.
  final GithubActionStatus status;

  /// A conclusion of this workflow run job.
  final GithubActionConclusion conclusion;

  /// A [DateTime] of this workflow run job's start.
  final DateTime startedAt;

  /// A [DateTime] of this workflow run job's completion.
  final DateTime completedAt;

  @override
  List<Object> get props =>
      [id, runId, name, url, status, conclusion, startedAt, completedAt];

  /// Creates a new instance of the [WorkflowRunJob].
  const WorkflowRunJob({
    this.id,
    this.runId,
    this.name,
    this.url,
    this.status,
    this.conclusion,
    this.startedAt,
    this.completedAt,
  });

  /// Creates a new instance of the [WorkflowRunJob] from the decoded JSON
  /// object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory WorkflowRunJob.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const statusMapper = GithubActionStatusMapper();
    final status = statusMapper.map(json['status'] as String);

    const conclusionMapper = GithubActionConclusionMapper();
    final conclusion = conclusionMapper.map(json['conclusion'] as String);

    final startedAt = json['started_at'] == null
        ? null
        : DateTime.parse(json['started_at'] as String);

    final completedAt = json['completed_at'] == null
        ? null
        : DateTime.parse(json['completed_at'] as String);

    return WorkflowRunJob(
      id: json['id'] as int,
      runId: json['run_id'] as int,
      name: json['name'] as String,
      url: json['html_url'] as String,
      status: status,
      conclusion: conclusion,
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }

  /// Creates a list of [WorkflowRunJob]s from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<WorkflowRunJob> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => WorkflowRunJob.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this run job instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const statusMapper = GithubActionStatusMapper();
    const conclusionMapper = GithubActionConclusionMapper();

    return <String, dynamic>{
      'id': id,
      'run_id': runId,
      'name': name,
      'html_url': url,
      'status': statusMapper.unmap(status),
      'conclusion': conclusionMapper.unmap(conclusion),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WorkflowRunJob ${toJson()}';
  }
}

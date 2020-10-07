import 'package:ci_integration/client/github_actions/mappers/run_conclusion_mapper.dart';
import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a single Github Actions workflow run.
class WorkflowRun extends Equatable {
  /// A unique identifier of this workflow run.
  final int id;

  /// An order number of this workflow run in the repository.
  final int number;

  /// A link to access this workflow run in Github.
  final String url;

  /// A status of this workflow run.
  final RunStatus status;

  /// A conclusion of this workflow run.
  final RunConclusion conclusion;

  /// A timestamp this workflow run has started at.
  final DateTime createdAt;

  @override
  List<Object> get props => [id, number, url, status, conclusion, createdAt];

  /// Creates a new instance of the [WorkflowRun].
  const WorkflowRun({
    this.id,
    this.number,
    this.url,
    this.status,
    this.conclusion,
    this.createdAt,
  });

  /// Creates a new instance of the [WorkflowRun] from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory WorkflowRun.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const statusMapper = RunStatusMapper();
    final status = statusMapper.map(json['status'] as String);

    const conclusionMapper = RunConclusionMapper();
    final conclusion = conclusionMapper.map(json['conclusion'] as String);

    final createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String);

    return WorkflowRun(
      id: json['id'] as int,
      number: json['run_number'] as int,
      url: json['url'] as String,
      status: status,
      conclusion: conclusion,
      createdAt: createdAt,
    );
  }

  /// Creates a list of [WorkflowRun] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<WorkflowRun> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => WorkflowRun.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this run instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const statusMapper = RunStatusMapper();
    const conclusionMapper = RunConclusionMapper();

    return <String, dynamic>{
      'id': id,
      'run_number': number,
      'url': url,
      'status': statusMapper.unmap(status),
      'conclusion': conclusionMapper.unmap(conclusion),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

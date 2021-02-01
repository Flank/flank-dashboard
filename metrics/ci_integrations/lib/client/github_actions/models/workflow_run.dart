import 'package:ci_integration/client/github_actions/mappers/github_action_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a single Github Actions workflow run.
class WorkflowRun extends Equatable {
  /// A unique identifier of this workflow run.
  final int id;

  /// An order number of this workflow run in the repository.
  final int number;

  /// A link to access this workflow run in Github web UI.
  final String url;

  /// A link to access data of this workflow run using Github Actions API.
  final String apiUrl;

  /// A status of this workflow run.
  final GithubActionStatus status;

  /// A timestamp this workflow run has started at.
  final DateTime createdAt;

  @override
  List<Object> get props => [id, number, url, status, createdAt];

  /// Creates a new instance of the [WorkflowRun].
  const WorkflowRun({
    this.id,
    this.number,
    this.url,
    this.apiUrl,
    this.status,
    this.createdAt,
  });

  /// Creates a new instance of the [WorkflowRun] from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory WorkflowRun.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const statusMapper = GithubActionStatusMapper();
    final status = statusMapper.map(json['status'] as String);

    final createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String);

    return WorkflowRun(
      id: json['id'] as int,
      number: json['run_number'] as int,
      url: json['html_url'] as String,
      apiUrl: json['url'] as String,
      status: status,
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
    const statusMapper = GithubActionStatusMapper();

    return <String, dynamic>{
      'id': id,
      'run_number': number,
      'url': apiUrl,
      'html_url': url,
      'status': statusMapper.unmap(status),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WorkflowRun ${toJson()}';
  }
}

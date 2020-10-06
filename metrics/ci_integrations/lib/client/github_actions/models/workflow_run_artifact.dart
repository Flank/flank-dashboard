import 'package:equatable/equatable.dart';

/// A class that represents the single Github Actions workflow run artifact.
class WorkflowRunArtifact extends Equatable {
  /// The unique id of this run artifact.
  final int id;

  /// The name of this run artifact.
  final String name;

  /// The url needed to download this run artifact.
  final String downloadUrl;

  @override
  List<Object> get props => [id, name, downloadUrl];

  /// Creates a new instance of the [WorkflowRunArtifact].
  const WorkflowRunArtifact({
    this.id,
    this.name,
    this.downloadUrl,
  });

  /// Creates an instance of the [WorkflowRunArtifact] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory WorkflowRunArtifact.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return WorkflowRunArtifact(
      id: json['id'] as int,
      name: json['name'] as String,
      downloadUrl: json['archive_download_url'] as String,
    );
  }

  /// Creates a list of Github Actions workflow run artifacts from the [list] of
  /// decoded JSON objects.
  ///
  /// Returns `null` if the given list is `null`.
  static List<WorkflowRunArtifact> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) =>
            WorkflowRunArtifact.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this workflow run artifact instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'archive_download_url': downloadUrl,
    };
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

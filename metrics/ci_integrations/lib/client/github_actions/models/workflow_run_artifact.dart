// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents an artifact of a Github Actions workflow run.
class WorkflowRunArtifact extends Equatable {
  /// A unique identifier of this artifact.
  final int id;

  /// A name of this artifact.
  final String name;

  /// A URL needed to download this artifact.
  final String downloadUrl;

  @override
  List<Object> get props => [id, name, downloadUrl];

  /// Creates a new instance of the [WorkflowRunArtifact].
  const WorkflowRunArtifact({
    this.id,
    this.name,
    this.downloadUrl,
  });

  /// Creates a new instance of the [WorkflowRunArtifact] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory WorkflowRunArtifact.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return WorkflowRunArtifact(
      id: json['id'] as int,
      name: json['name'] as String,
      downloadUrl: json['archive_download_url'] as String,
    );
  }

  /// Creates a list of [WorkflowRunArtifact] from the given [list] of decoded
  /// JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<WorkflowRunArtifact> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) =>
            WorkflowRunArtifact.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this artifact instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'archive_download_url': downloadUrl,
    };
  }

  @override
  String toString() {
    return 'WorkflowRunArtifact ${toJson()}';
  }
}

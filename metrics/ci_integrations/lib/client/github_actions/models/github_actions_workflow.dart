// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Github Actions workflow.
class GithubActionsWorkflow extends Equatable {
  /// A unique identifier of this workflow.
  final int id;

  /// A name of this workflow.
  final String name;

  /// A path to the workflow configuration file.
  final String path;

  /// Creates an instance of the [GithubActionsWorkflow] with the given parameters.
  const GithubActionsWorkflow({
    this.id,
    this.name,
    this.path,
  });

  @override
  List<Object> get props => [id, name, path];

  /// Creates a new instance of the [GithubActionsWorkflow] from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory GithubActionsWorkflow.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return GithubActionsWorkflow(
      id: json['id'] as int,
      name: json['name'] as String,
      path: json['path'] as String,
    );
  }

  /// Creates a list of [GithubActionsWorkflow] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<GithubActionsWorkflow> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) =>
            GithubActionsWorkflow.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this workflow instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
    };
  }
}

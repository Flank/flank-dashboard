// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_user.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a Github repository.
class GithubRepository extends Equatable {
  /// A unique identifier of this repository.
  final int id;

  /// A name of this repository.
  final String name;

  /// An owner of this repository.
  final GithubUser owner;

  /// Creates an instance of the [GithubRepository] with the given parameters.
  const GithubRepository({
    this.id,
    this.name,
    this.owner,
  });

  @override
  List<Object> get props => [id, name, owner];

  /// Creates a new instance of the [GithubRepository] from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory GithubRepository.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final owner = GithubUser.fromJson(json['owner'] as Map<String, dynamic>);

    return GithubRepository(
      id: json['id'] as int,
      name: json['name'] as String,
      owner: owner,
    );
  }

  /// Creates a list of [GithubRepository] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<GithubRepository> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => GithubRepository.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this run instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'owner': owner?.toJson(),
    };
  }

  @override
  String toString() {
    return 'GithubRepository ${toJson()}';
  }
}

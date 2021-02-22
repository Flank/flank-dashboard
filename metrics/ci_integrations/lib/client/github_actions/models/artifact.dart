// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Github Actions artifact.
class Artifact extends Equatable {
  /// A unique identifier of this artifact.
  final int id;

  /// A name of this artifact.
  final String name;

  /// Creates an instance of the [Artifact] with the given parameters.
  const Artifact({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [id, name];

  /// Creates a new instance of the [Artifact] from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory Artifact.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return Artifact(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  /// Creates a list of [Artifact] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<Artifact> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => Artifact.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this run instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Artifact ${toJson()}';
  }
}

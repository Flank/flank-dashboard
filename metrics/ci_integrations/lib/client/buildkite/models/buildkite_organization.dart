// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Buildkite organization.
class BuildkiteOrganization extends Equatable {
  /// A unique identifier of this organization.
  final String id;

  /// A name of this organization.
  final String name;

  /// A slug of this organization.
  final String slug;

  @override
  List<Object> get props => [id, name, slug];

  /// Creates an instance of the [BuildkiteOrganization]
  /// with the given parameters.
  const BuildkiteOrganization({
    this.id,
    this.name,
    this.slug,
  });

  /// Creates a new instance of the [BuildkiteOrganization] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteOrganization.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final id = json['id'] as String;
    final name = json['name'] as String;
    final slug = json['slug'] as String;

    return BuildkiteOrganization(id: id, name: name, slug: slug);
  }

  /// Creates a list of [BuildkiteOrganization]s from the given [list] of
  /// decoded JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkiteOrganization> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return BuildkiteOrganization.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  /// Converts this organization instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'slug': slug,
    };
  }

  @override
  String toString() {
    return 'BuildkiteOrganization ${toJson()}';
  }
}

// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Buildkite pipeline.
class BuildkitePipeline extends Equatable {
  /// A unique identifier of this pipeline.
  final String id;

  /// A name of this pipeline;
  final String name;

  /// A slug of this pipeline.
  final String slug;

  @override
  List<Object> get props => [id, name, slug];

  /// Creates an instance of the [BuildkitePipeline] with the given parameters.
  const BuildkitePipeline({
    this.id,
    this.name,
    this.slug,
  });

  /// Creates a new instance of the [BuildkitePipeline] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkitePipeline.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final id = json['id'] as String;
    final name = json['name'] as String;
    final slug = json['slug'] as String;

    return BuildkitePipeline(id: id, name: name, slug: slug);
  }

  /// Creates a list of [BuildkitePipeline]s from the given [list] of
  /// decoded JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkitePipeline> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return BuildkitePipeline.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  /// Converts this pipeline instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'slug': slug,
    };
  }

  @override
  String toString() {
    return 'BuildkitePipeline ${toJson()}';
  }
}

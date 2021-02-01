import 'package:equatable/equatable.dart';

/// A class that represents a Buildkite pipeline.
class BuildkitePipeline extends Equatable {
  /// A slug of this pipeline.
  final String slug;

  @override
  List<Object> get props => [slug];

  /// Creates an instance of the [BuildkitePipeline] with the given [slug].
  const BuildkitePipeline({
    this.slug,
  });

  /// Creates a new instance of the [BuildkitePipeline] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkitePipeline.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final slug = json['slug'] as String;

    return BuildkitePipeline(slug: slug);
  }

  /// Creates a list of [BuildkitePipeline] from the given [list] of
  /// decoded JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkitePipeline> listFromJson(List<dynamic> list) {
    return list
        ?.map(
          (json) => BuildkitePipeline.fromJson(json as Map<String, dynamic>),
        )
        ?.toList();
  }

  /// Converts this pipeline slug into the JSON encodable [String].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'slug': slug,
    };
  }

  @override
  String toString() {
    return 'BuildkitePipeline ${toJson()}';
  }
}

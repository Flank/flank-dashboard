import 'package:equatable/equatable.dart';

/// A class that represents a Buildkite organization.
class BuildkiteOrganization extends Equatable {
  /// A name of this organization.
  final String name;

  @override
  List<Object> get props => [name];

  /// Creates an instance of the [BuildkiteOrganization] with the given [name].
  const BuildkiteOrganization({
    this.name,
  });

  /// Creates a new instance of the [BuildkiteOrganization] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteOrganization.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final name = (json['name'] as dynamic)?.toString();

    return BuildkiteOrganization(name: name);
  }

  /// Creates a list of [BuildkiteOrganization] from the given [list] of
  /// decoded JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkiteOrganization> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) =>
            BuildkiteOrganization.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this organization name into the JSON encodable [String].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
    };
  }

  @override
  String toString() {
    return 'BuildkiteOrganization ${toJson()}';
  }
}

import 'package:ci_integration/client/buildkite/mappers/buildkite_token_permission_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_permission.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a Buildkite access token needed for authorization.
class BuildkiteToken extends Equatable {
  /// A [List] of [BuildkiteTokenPermission]s of this token.
  final List<BuildkiteTokenPermission> permissions;

  @override
  List<Object> get props => [permissions];

  /// Creates an instance of the [BuildkiteToken] with the given [permissions].
  const BuildkiteToken({
    this.permissions,
  });

  /// Creates a new instance of the [BuildkiteToken] from the decoded JSON
  /// object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteToken.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const permissionMapper = BuildkiteTokenPermissionMapper();
    final permissionsList =
        (json['scopes'] as List<dynamic>)?.map((element) => '$element');

    final permissions = permissionsList?.map(permissionMapper.map)?.toList();

    return BuildkiteToken(permissions: permissions);
  }

  /// Creates a list of [BuildkiteToken] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkiteToken> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => BuildkiteToken.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this token instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const persmissionMapper = BuildkiteTokenPermissionMapper();

    final permissionsList = permissions.map(persmissionMapper.unmap).toList();

    return <String, dynamic>{
      'scopes': permissionsList,
    };
  }

  @override
  String toString() {
    return 'BuildkiteToken ${toJson()}';
  }
}

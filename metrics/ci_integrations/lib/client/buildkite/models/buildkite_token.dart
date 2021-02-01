import 'package:ci_integration/client/buildkite/mappers/buildkite_token_scope_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a Buildkite access token needed for authorization.
class BuildkiteToken extends Equatable {
  /// A [List] of [BuildkiteTokenScope]s of this token.
  final List<BuildkiteTokenScope> scopes;

  @override
  List<Object> get props => [scopes];

  /// Creates an instance of the [BuildkiteToken] with the given [scopes].
  const BuildkiteToken({
    this.scopes,
  });

  /// Creates a new instance of the [BuildkiteToken] from the decoded JSON
  /// object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteToken.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const scopeMapper = BuildkiteTokenScopeMapper();
    final scopesValue = json['scopes'] as List<dynamic>;
    final scopesList = scopesValue?.map((element) => '$element');

    final scopes = scopesList?.map(scopeMapper.map)?.toList();

    return BuildkiteToken(scopes: scopes);
  }

  /// Creates a list of [BuildkiteToken]s from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkiteToken> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return BuildkiteToken.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  /// Converts this token instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const scopeMapper = BuildkiteTokenScopeMapper();

    final scopesList = scopes?.map(scopeMapper.unmap)?.toList();

    return <String, dynamic>{
      'scopes': scopesList,
    };
  }

  @override
  String toString() {
    return 'BuildkiteToken ${toJson()}';
  }
}

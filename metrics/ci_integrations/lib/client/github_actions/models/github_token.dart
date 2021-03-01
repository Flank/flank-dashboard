// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a Github access token used for API requests authorization.
class GithubToken extends Equatable {
  /// A [List] of [GithubTokenScope]s of this token.
  final List<GithubTokenScope> scopes;

  @override
  List<Object> get props => [scopes];

  /// Creates an instance of the [GithubToken] with the given [scopes].
  const GithubToken({
    this.scopes,
  });

  /// Creates a new instance of the [GithubToken]
  /// from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory GithubToken.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    const scopeMapper = GithubTokenScopeMapper();
    final scopesList = json['scopes'] as List<String>;

    final scopes = scopesList?.map(scopeMapper.map)?.toList();

    if (scopes.length == 1 && scopes.first == null) {
      return const GithubToken(scopes: []);
    }

    return GithubToken(scopes: scopes);
  }

  /// Creates a new instance of the [GithubToken] from the given [map].
  ///
  /// Returns `null` if the given [map] is `null`.
  factory GithubToken.fromMap(Map<String, String> map) {
    if (map == null) return null;

    final scopes = map['x-oauth-scopes'] ?? '';
    final scopesList = scopes.split(',').map((e) => e.trim()).toList();

    return GithubToken.fromJson({'scopes': scopesList});
  }

  /// Creates a list of [GithubToken]s
  /// from the given [list] of decoded JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<GithubToken> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return GithubToken.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  /// Converts this token instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    const scopeMapper = GithubTokenScopeMapper();

    final scopesList = scopes?.map(scopeMapper.unmap)?.toList();

    return {
      'scopes': scopesList,
    };
  }
}

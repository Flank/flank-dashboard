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

  /// Creates a new instance of the [GithubToken] from the given [map].
  ///
  /// Returns `null` if the given [map] is `null`.
  factory GithubToken.fromMap(Map<String, String> map) {
    if (map == null) return null;

    final scopesValue = map['x-oauth-scopes'] ?? '';
    print('scopesValue: $scopesValue');
    final scopesList = scopesValue.split(', ');

    // final scopesValue = map['x-oauth-scopes'] as List<String>;
    // final scopesList = scopesValue?.map((element) => '$element');

    List<GithubTokenScope> scopes = [];

    if (scopesValue.isNotEmpty) {
      const scopeMapper = GithubTokenScopeMapper();
      scopes = scopesList?.map(scopeMapper.map)?.toList();
    }

    return GithubToken(scopes: scopes);
  }

  /// Converts this token instance into the JSON encodable [Map].
  Map<String, String> toMap() {
    const scopeMapper = GithubTokenScopeMapper();

    final scopesList = scopes?.map(scopeMapper.unmap)?.toList();

    return {
      'x-oauth-scopes': scopesList.toString(),
    };
  }
}

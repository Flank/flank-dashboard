// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Github user.
class GithubUser extends Equatable {
  /// A unique identifier of this user.
  final int id;

  /// A login string of this user.
  final String login;

  /// Creates an instance of the [GithubUser] with the given parameters.
  const GithubUser({
    this.id,
    this.login,
  });

  @override
  List<Object> get props => [id, login];

  /// Creates a new instance of the [GithubUser] from the decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory GithubUser.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return GithubUser(
      id: json['id'] as int,
      login: json['login'] as String,
    );
  }

  /// Creates a list of [GithubUser] from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<GithubUser> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => GithubUser.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this run instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'login': login,
    };
  }

  @override
  String toString() {
    return 'GithubUser ${toJson()}';
  }
}

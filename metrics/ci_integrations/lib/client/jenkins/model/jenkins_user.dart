// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Jenkins user.
class JenkinsUser extends Equatable {
  /// A unique identifier of this user.
  final String id;

  /// A full name of this user.
  final String fullName;

  @override
  List<Object> get props => [id, fullName];

  /// Creates a new instance of the [JenkinsUser] with the given [id]
  /// and [fullName].
  const JenkinsUser({
    this.id,
    this.fullName,
  });

  /// Creates a new instance of the [JenkinsUser] from the decoded JSON
  /// object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory JenkinsUser.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
    );
  }

  /// Creates a list of [JenkinsUser]s from the given [list] of decoded JSON
  /// objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<JenkinsUser> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JenkinsUser.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  /// Converts this user instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
    };
  }

  @override
  String toString() {
    return 'JenkinsUser ${toJson()}';
  }
}

// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Jenkins application instance.
class JenkinsInstanceInfo extends Equatable {
  /// A [String] that represents the version of this Jenkins instance.
  final String version;

  @override
  List<Object> get props => [version];

  /// Creates a new instance of the [JenkinsInstanceInfo] with the given
  /// [version].
  const JenkinsInstanceInfo({this.version});

  /// Creates a new instance of the [JenkinsInstanceInfo] from the decoded JSON
  /// object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory JenkinsInstanceInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsInstanceInfo(
      version: json['X-Jenkins'] as String,
    );
  }

  /// Creates a list of [JenkinsInstanceInfo]s from the given [list] of decoded
  /// JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<JenkinsInstanceInfo> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JenkinsInstanceInfo.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  /// Converts this Jenkins instance information into the JSON encodable
  /// [Map].
  Map<String, dynamic> toJson() {
    return {
      'X-Jenkins': version,
    };
  }

  @override
  String toString() {
    return 'JenkinsInstanceInfo ${toJson()}';
  }
}

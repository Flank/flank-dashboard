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
  const JenkinsInstanceInfo({
    this.version,
  });

  /// Creates a new instance of the [JenkinsInstanceInfo] from the given [map].
  ///
  /// Returns `null` if the given [map] is `null`.
  factory JenkinsInstanceInfo.fromMap(Map<String, String> map) {
    if (map == null) return null;

    return JenkinsInstanceInfo(
      version: map['x-jenkins'],
    );
  }

  /// Converts this Jenkins instance information into the [Map].
  Map<String, String> toMap() {
    return {
      'x-jenkins': version,
    };
  }

  @override
  String toString() {
    return 'JenkinsInstanceInfo ${toMap()}';
  }
}

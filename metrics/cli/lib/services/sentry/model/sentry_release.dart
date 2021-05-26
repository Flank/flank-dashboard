// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/sentry/model/sentry_project.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a Sentry release.
class SentryRelease extends Equatable {
  /// A name of this Sentry release.
  final String name;

  /// A [SentryProject] this release belongs to.
  final SentryProject project;

  @override
  List<Object> get props => [name, project];

  /// Creates a new instance of the [SentryRelease]
  /// with the given [name] and [project].
  ///
  /// Throws an [ArgumentError] if the given [name] is `null`.
  /// Throws an [ArgumentError] if the given [project] is `null`.
  SentryRelease({this.name, this.project}) {
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(project, 'project');
  }
}

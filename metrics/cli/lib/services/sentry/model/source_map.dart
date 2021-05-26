// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a source map.
class SourceMap extends Equatable {
  /// A path to the sources.
  final String path;

  /// A [List] of file extensions.
  final List<String> extensions;

  @override
  List<Object> get props => [path, extensions];

  /// Creates a new instance of the [SourceMap]
  /// with the given [path] and [extensions].
  ///
  /// Throws an [ArgumentError] if the given [path] is `null`.
  /// Throws an [ArgumentError] if the given [extensions] is `null`.
  SourceMap({this.path, this.extensions}) {
    ArgumentError.checkNotNull(path, 'path');
    ArgumentError.checkNotNull(extensions, 'extensions');
  }
}

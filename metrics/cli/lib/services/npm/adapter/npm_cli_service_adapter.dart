// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/npm/cli/npm_cli.dart';
import 'package:cli/services/npm/npm_service.dart';

/// An adapter for the [NpmCli] to implement the [NpmService] interface.
class NpmCliServiceAdapter extends NpmService {
  /// An [NpmCli] class that provides an ability to interact with the Npm CLI.
  final NpmCli _npmCli;

  /// Creates a new instance of the [NpmCliServiceAdapter]
  /// with the given [NpmCli].
  ///
  /// Throws an [ArgumentError] if the given [NpmCli] is `null`.
  NpmCliServiceAdapter(this._npmCli) {
    ArgumentError.checkNotNull(_npmCli, 'npmCli');
  }

  @override
  Future<void> installDependencies(String path) {
    return _npmCli.install(path);
  }

  @override
  Future<void> version() {
    return _npmCli.version();
  }
}

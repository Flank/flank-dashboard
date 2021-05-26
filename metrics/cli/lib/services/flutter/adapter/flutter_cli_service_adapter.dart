// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/flutter/cli/flutter_cli.dart';
import 'package:cli/services/flutter/flutter_service.dart';

/// An adapter for the [FlutterCli] to implement the [FlutterService]
/// interface.
class FlutterCliServiceAdapter implements FlutterService {
  /// A [FlutterCli] class that provides an ability to interact
  /// with the Flutter CLI.
  final FlutterCli _flutterCli;

  /// Creates a new instance of the [FlutterCliServiceAdapter]
  /// with the given [FlutterCli].
  ///
  /// Throws an [ArgumentError] if the given [FlutterCli] is `null`.
  FlutterCliServiceAdapter(this._flutterCli) {
    ArgumentError.checkNotNull(_flutterCli, 'flutterCli');
  }

  @override
  Future<void> build(String appPath) async {
    await _flutterCli.enableWeb();
    await _flutterCli.buildWeb(appPath);
  }

  @override
  Future<void> version() {
    return _flutterCli.version();
  }
}

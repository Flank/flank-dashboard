// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart';

import 'process_runner.dart';

/// A base class for all web drivers [ProcessRunner]s.
///
/// Provides a common for web drivers implementation of the [isAppStarted] method
/// detecting whether the driver status is ready using the [statusRequestUrl].
abstract class WebDriverProcessRunner extends ProcessRunner {
  /// A port that running driver should listen to.
  static const int port = 4444;

  /// A URL needed to perform the web driver status checks.
  String get statusRequestUrl;

  @override
  Future<void> isAppStarted() async {
    bool driverIsUp = false;

    while (!driverIsUp) {
      final driverResponse =
          await get(statusRequestUrl).catchError((_) => null);

      if (driverResponse == null) continue;

      final driverResponseBody = jsonDecode(driverResponse.body);

      driverIsUp = driverResponseBody['value']['ready'] as bool;
    }
  }
}

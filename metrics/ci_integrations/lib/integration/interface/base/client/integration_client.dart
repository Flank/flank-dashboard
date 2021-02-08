// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:http/http.dart';

/// An abstract class representing an integration client.
abstract class IntegrationClient {
  /// Closes this client and cleans up any resources associated with it.
  /// Similar to [Client.close].
  FutureOr<void> dispose();
}

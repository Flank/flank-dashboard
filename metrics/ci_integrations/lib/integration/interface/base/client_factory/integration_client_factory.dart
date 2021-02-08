// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/interface/base/client/integration_client.dart';
import 'package:ci_integration/integration/interface/base/config/model/config.dart';

/// An abstract class providing method for creating [IntegrationClient]s.
abstract class IntegrationClientFactory<T extends Config,
    K extends IntegrationClient> {
  /// Creates the [IntegrationClient] instance using the given [config].
  ///
  /// Throws an [ArgumentError], if the given [config] is `null`.
  FutureOr<K> create(T config);
}

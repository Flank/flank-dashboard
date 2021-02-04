// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/client_factory/integration_client_factory.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';

/// An abstract class providing method for creating [DestinationClient]s.
abstract class DestinationClientFactory<T extends DestinationConfig,
    K extends DestinationClient> extends IntegrationClientFactory<T, K> {}

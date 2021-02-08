// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/party/integration_party.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';

/// An abstract class representing an integration party
/// for a destination storage integration.
abstract class DestinationParty<T extends DestinationConfig,
    K extends DestinationClient> extends IntegrationParty<T, K> {}

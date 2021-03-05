// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';
import 'package:ci_integration/integration/interface/destination/party/destination_party.dart';
import 'package:mockito/mockito.dart';

class DestinationPartyMock<T extends DestinationConfig,
        K extends DestinationClient> extends Mock
    implements DestinationParty<T, K> {}
